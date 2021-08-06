# How to contribute

## Create a fork at your github space
Go to https://github.com/syseleven/puppet-restic and press "Fork".

## Checkout your forked repository
```shell
git clone <your forked repository>
```

## Create a branch at the cloned repository
Use meaningful branch names, e.g. the issue id.
```
git checkout -b <branch_name>
```

## Make your changes
Only changes related to the named issue will be accepted.

## Run the test
We are running some tests to ensure style, syntax, and so on.
```shell
bundle install
bundle exec rake test
```

## Commit and push your changes
Please use meaningful commit messages.
```shell
git commit -m "fixes issue #<id>"
git push -u origin HEAD
```

## Rebase your branch
Keep your forked main always in sync with our main and rebase your branch with your main.

Update your main branch:
```shell
git checkout main
git pull --rebase
git remote add syseleven https://github.com/syseleven/puppet-restic.git
git rebase syseleven/main
git push
```

Rebase your feature branch:
```shell
git checkout <feature-branch>
git rebase main
git push -f
```

## Create a pull request
After you have pushed your feature branch to your github space you can create a pull request.

## Eat some cookies
Since we all love cookies and to celebrate the open source culture eat some cookies of your choice.
