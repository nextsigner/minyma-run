import QtQuick 2.0
import QtQuick.Controls 2.0
import unik.UnikQProcess 1.0
ApplicationWindow{
    id: app
    visible: false

    MinymaClient{
        id: minymaClient
        loginUserName: 'minyma-run'
        onNewMessage: {
            //let json=JSON.parse(data)
            //log.ls('Minyma Recibe: '+data, 0, 500)
        }
        onNewMessageForMe: {
            console.log('From '+from+' say '+data)
            mkUqp(data, from, minymaClient.loginUserName)
        }
    }

    function mkUqp(cmd, from, to){
        let d=new Date(Date.now())
        let ms=d.getTime()
        let c='import QtQuick 2.0\n'
        c+='import unik.UnikQProcess 1.0\n'
        c+='UnikQProcess{\n'
        c+='    id: uqp'+ms+'\n'
        c+='    property string from:\"'+from+'\"\n'
        c+='    property string to:\"'+to+'\"\n'
        c+='    onLogDataChanged: {\n'
        c+='        console.log(\'LogData from:'+from+' to: '+to+' \'+logData)\n'
        c+='        console.log(\'LogData id'+ms+': \'+logData)\n'
        c+='        minymaClient.sendData(uqp'+ms+'.to, uqp'+ms+'.from, logData)\n'
        c+='    }\n'
        c+='    onFinished: {\n'
        c+='        minymaClient.sendData(uqp'+ms+'.to, uqp'+ms+'.from, \'finished\')\n'
        c+='        uqp'+ms+'.destroy(1)\n'
        c+='    }\n'
        c+='    onStarted: {\n'
        c+='        minymaClient.sendData(uqp'+ms+'.to, uqp'+ms+'.from, \'started\')\n'
        c+='    }\n'
        c+='    Component.onCompleted: {\n'
        c+='        uqp'+ms+'.run(\"'+cmd+'\")\n'
        c+='    }\n'
        c+='}\n'
        //console.log('Code:\n'+c)
        let comp=Qt.createQmlObject(c,app,'uqpcode'+ms)
    }
}
