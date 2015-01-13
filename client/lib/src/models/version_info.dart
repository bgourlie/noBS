part of fitlog_models;

@Injectable()
class VersionInfo {
  final String version;
  final String build;
  final String commitId;
  final String branch;
  final String buildTime;
  const VersionInfo(
      this.version, this.build, this.commitId, this.branch, this.buildTime);
}
