contract ApirTransfer {
  string transferData;

  function set(string x) {
    transferData = x;
  }

  function get() constant returns (string retVal) {
    return transferData;
  }
}
