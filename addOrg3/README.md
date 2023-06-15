## Adding Ecuador to the test network

You can use the `addEcuador.sh` script to add another organization to the Fabric test network. The `addEcuador.sh` script generates the Ecuador crypto material, creates an Ecuador organization definition, and adds Ecuador to a channel on the test network.

You first need to run `./network.sh up createChannel` in the `test-network` directory before you can run the `addEcuador.sh` script.

```
./network.sh up createChannel
cd addEcuador
./addEcuador.sh up
```

If you used `network.sh` to create a channel other than the default `channeluniversidades`, you need pass that name to the `addecuador.sh` script.
```
./network.sh up createChannel -c channel1
cd addEcuador
./addEcuador.sh up -c channel1
```

You can also re-run the `addEcuador.sh` script to add Ecuador to additional channels.
```
cd ..
./network.sh createChannel -c channel2
cd addEcuador
./addEcuador.sh up -c channel2
```

For more information, use `./addEcuador.sh -h` to see the `addEcuador.sh` help text.
