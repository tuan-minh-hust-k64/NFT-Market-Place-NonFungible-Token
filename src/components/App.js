import detectEthereumProvider from "@metamask/detect-provider";
import * as React from "react"
import Web3 from "web3";
import KryptoBird from "../abis/KryptoBird.json";
const App = () => {
  const [account, setAccount] = React.useState('');
  async function checkMetamask  () {
    const provider = await detectEthereumProvider();
    if(provider){
      console.log('successfully detected');
      window.web3 = new Web3(provider);

      const acc = await window.web3.eth.getAccounts();
      setAccount(acc);
      const id =await window.web3.eth.net.getId();
      const address = KryptoBird.networks[id].address;
      const abi = KryptoBird.abi;
      const contract = new window.web3.eth.Contract(abi, address);
      console.log(contract);
    }else{
      console.log('failure detected');
    }
  }
  React.useEffect(() =>{
    checkMetamask()
  }, [])
  return (
    <div>
      <nav className='navbar navbar-dark fixed-top bg-dark flex-md-nowrap p-0 shadow' >
        <div className='navbar-brand col-sm-3 col-md-3 mr-0' style={{color: 'white'}} >
          Krypto Bidz NFTs (Non Fungible Token)
        </div>
        <ul className='navbar-nav px-3' >
          <l className='nav-item text-nowrap d-none d-sm-none d-sm-block' >
            <small className='text-white'>
              {account}
            </small>
          </l>
        </ul>
      </nav>
    </div>
  );
};
export default App;
