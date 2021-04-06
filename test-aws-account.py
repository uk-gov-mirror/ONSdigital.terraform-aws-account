import os
import pytest
import tftest

envs = {
    'AWS_REGION': 'eu-west-2'
}


@pytest.fixture
def plan(fixtures_dir):
    tf = tftest.TerraformTest(tfdir=fixtures_dir, terraform='/usr/local/bin/terraform', env=envs)
    tf.init()
    return tf.plan(output=True)


def test_restricted_admin_role_and_policy_exists_in_dev_and_iam_aws_account(plan):
    dev_account = plan.modules['module.dev']
    should_not_be_none = []
    dev_restricted_admin_role = dev_account.resources['aws_iam_role.restricted_admin_dev[0]']
    dev_restricted_admin_policy = dev_account.resources['aws_iam_policy.restricted_admin_dev[0]']

    should_not_be_none.extend((dev_restricted_admin_policy, dev_restricted_admin_role))
    assert all(resource is not None for resource in should_not_be_none)


def test_restricted_admin_role_and_policy_does_not_exists_in_non_dev_and_iam_aws_account(plan):
    test_account = plan.modules['module.test']
    iam_account = plan.modules['module.iam']

    with pytest.raises(KeyError):
        test_account.resources['aws_iam_role.restricted_admin_dev[0]']
        test_account.resources['aws_iam_policy.restricted_admin_dev[0]']
        iam_account.resources['aws_iam_role.restricted_admin_dev[0]']
        iam_account.resources['aws_iam_policy.restricted_admin_dev[0]']


def test_route53_resources_not_exist_when_aws_account_is_type_iam(plan):
    iam_account = plan.modules['module.iam']
    with pytest.raises(KeyError):
        iam_account.resources['aws_route53_zone.zone[0]']
