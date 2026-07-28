import 'package:flutter_test/flutter_test.dart';
import 'package:knight_os/core/services/github_release_update_provider.dart';

void main() {
  group('GitHubReleaseUpdateProvider', () {
    test(
      'compares semantic versions numerically and ignores v/build metadata',
      () {
        final provider = GitHubReleaseUpdateProvider(
          owner: 'owner',
          repo: 'repo',
        );

        expect(provider.compareVersions('v0.1.0', '0.1.0'), 0);
        expect(provider.compareVersions('0.1.0', '0.1.1'), -1);
        expect(provider.compareVersions('1.0.0', '0.1.99'), 1);
        expect(provider.compareVersions('1.0.1', '1.0.0'), 1);
        expect(provider.isVersionAtLeast('1.0.0+1', '2.0.0'), isFalse);
        expect(provider.isVersionAtLeast('2.0.0', '2.0.0'), isTrue);
      },
    );

    test(
      'compares the installed app version with the v2.0.0 release correctly',
      () {
        final provider = GitHubReleaseUpdateProvider(
          owner: 'owner',
          repo: 'repo',
        );

        expect(provider.normalizeVersion('1.0.0+1'), '1.0.0');
        expect(provider.normalizeVersion('v2.0.0'), '2.0.0');
        expect(provider.compareVersions('1.0.0', '2.0.0'), -1);
        expect(provider.isVersionAtLeast('1.0.0', '2.0.0'), isFalse);
      },
    );

    test(
      'treats higher build metadata as newer when the semantic version is equal',
      () {
        final provider = GitHubReleaseUpdateProvider(
          owner: 'owner',
          repo: 'repo',
        );

        expect(provider.compareVersions('2.0.0+1', '2.0.0+2'), -1);
        expect(provider.compareVersions('2.0.0+2', '2.0.0+1'), 1);
        expect(provider.isVersionAtLeast('2.0.0+2', '2.0.0+1'), isTrue);
      },
    );
  });
}
