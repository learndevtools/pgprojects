public class GetDataIntoBas64 {
  @InvocableMethod
  public static List <String> execute (List<ContentVersion> requestList) {
      return new List<String>{EncodingUtil.base64Encode(Blob.valueOf('Hello Message'))};
      //return new List<String>{EncodingUtil.base64Encode(requestList?.get(0)?.VersionData)};
  }
}