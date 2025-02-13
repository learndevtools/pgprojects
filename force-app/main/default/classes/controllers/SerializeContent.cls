public class SerializeContent {
  @InvocableMethod
  public static List<String> execute (List<Requests> requestList) {
      system.debug('Hello');
      System.debug('JSON.serialize(requestList)='+JSON.serialize(requestList?.get(0)?.inputCollection));
      return new List<String>{JSON.serialize(requestList)};
  }
}