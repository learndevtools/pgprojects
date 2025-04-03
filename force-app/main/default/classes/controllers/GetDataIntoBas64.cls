/**
 * @description       : 
 * @author            : salesforce
 * @group             : 
 * @last modified on  : 04-02-2025
 * @last modified by  : salesforce
**/
public class GetDataIntoBas64 {
  @InvocableMethod
  public static List <String> execute (List<ContentVersion> requestList) {
      return new List<String>{EncodingUtil.base64Encode(Blob.valueOf('Hello Message1'))};
      //return new List<String>{EncodingUtil.base64Encode(requestList?.get(0)?.VersionData)};
  }
}