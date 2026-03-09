const { status } = require('express/lib/response');
const UserService=require('../services/user.services');

exports.register=async(req,res,next)=>{
    try{
        const {email,password}=req.body;

        const success= await UserService.registerUser(email,password);

        res.json({status:true,success:"User registered successful!"});
    }catch(err){
        throw err;
    }
}

exports.login=async(req,res,next)=>{
    try{
        const {email,password}=req.body;
         
        const user=UserService.checkuser(email);

        if(!user){
            throw new Error("User doesn't exist");
        }

        const isMatch=user.comparePassword(password);
        if(isMatch === false){
            throw new Error("Password invalid!");
        }

        let tokenData ={_id,email:user.email};

        const token=await UserService.generateToken(tokenData,"secretKey",'1h')

        res.status(200).json({status:true,token:token});
    }catch(err){
        throw err;
    }
}