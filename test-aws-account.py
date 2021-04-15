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


def test_administrator_role_and_policy_exist_in_dev_aws_account(plan):
    dev_account = plan.modules['module.dev']
    should_not_be_none = []
    administrator_role = dev_account.resources['aws_iam_role.administrator[0]']
    administrator_policy = dev_account.resources['aws_iam_policy.administrator[0]']

    should_not_be_none.extend((administrator_policy, administrator_role))
    assert all(resource is not None for resource in should_not_be_none)


def test_developer_role_and_policy_exist_in_dev_aws_account(plan):
    dev_account = plan.modules['module.dev']
    should_not_be_none = []
    developer_role = dev_account.resources['aws_iam_role.developer[0]']
    developer_policy = dev_account.resources['aws_iam_policy.developer[0]']

    should_not_be_none.extend((developer_policy, developer_role))
    assert all(resource is not None for resource in should_not_be_none)


def test_administrator_role_and_policy_does_not_exists_in_non_dev_aws_account(plan):
    test_account = plan.modules['module.test']

    with pytest.raises(KeyError):
        test_account.resources['aws_iam_role.administrator[0]']
        test_account.resources['aws_iam_policy.administrator[0]']


def test_developer_role_and_policy_does_not_exists_in_non_dev_aws_account(plan):
    test_account = plan.modules['module.test']

    with pytest.raises(KeyError):
        test_account.resources['aws_iam_role.developer[0]']
        test_account.resources['aws_iam_policy.developer[0]']


def test_route53_resources_not_exist_when_aws_account_is_type_iam(plan):
    iam_account = plan.modules['module.iam']
    with pytest.raises(KeyError):
        iam_account.resources['aws_route53_zone.zone[0]']
