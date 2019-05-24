Return-Path: <SRS0=Nb5J=TY=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,T_DKIMWL_WL_HIGH autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99A78C072B5
	for <linux-sgx@archiver.kernel.org>; Fri, 24 May 2019 15:41:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 51F16217D7
	for <linux-sgx@archiver.kernel.org>; Fri, 24 May 2019 15:41:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=tycho.nsa.gov header.i=@tycho.nsa.gov header.b="LRqpnxKS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389550AbfEXPlp (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 24 May 2019 11:41:45 -0400
Received: from upbd19pa08.eemsg.mail.mil ([214.24.27.83]:48315 "EHLO
        upbd19pa08.eemsg.mail.mil" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389419AbfEXPlp (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Fri, 24 May 2019 11:41:45 -0400
X-EEMSG-check-017: 227085674|UPBD19PA08_EEMSG_MP8.csd.disa.mil
Received: from emsm-gh1-uea10.ncsc.mil ([214.29.60.2])
  by upbd19pa08.eemsg.mail.mil with ESMTP/TLS/DHE-RSA-AES256-SHA256; 24 May 2019 15:41:35 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=tycho.nsa.gov; i=@tycho.nsa.gov; q=dns/txt;
  s=tycho.nsa.gov; t=1558712496; x=1590248496;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=fjRfdEqF2YZTgqWQSGz5+FqtDmpMbiPntPxe5XG213c=;
  b=LRqpnxKSLMLT5MNbgdcBflRAgm+vkAC4sBGlePfmz8/4KqQa2gVcyj/X
   iY5ZuopBKNGVoNsfrhQiuMec9ok9l17/MEAjn+mzXGbrbCKL43IDJq1ql
   D4E7YrdE12GV6bGl0u7eoCYcgHSJqZD9lTlvrh5AKPPZFpe6yaXMx7X3x
   LNwnZzzNlpFuEBb7wWu7UvtyZrWNT3t7uEAZUnNZxXZvB1yq3P9aBBAuV
   A+xGiZbxirMiaTPPy+zO2PEj/2ueoojsNNf1u3DMEN5lGKayO7PT2rAVp
   ZjeBLxHwxuN8zEENgQgqzMFIEn9lyIE4WcYDgJi+t95/ofyyYOQNphp5O
   g==;
X-IronPort-AV: E=Sophos;i="5.60,507,1549929600"; 
   d="scan'208";a="24073964"
IronPort-PHdr: =?us-ascii?q?9a23=3AlBOAWB+gD3Xuy/9uRHKM819IXTAuvvDOBiVQ1K?=
 =?us-ascii?q?B91ekeIJqq85mqBkHD//Il1AaPAdyCrasd1aGG4ujJYi8p2d65qncMcZhBBV?=
 =?us-ascii?q?cuqP49uEgeOvODElDxN/XwbiY3T4xoXV5h+GynYwAOQJ6tL1LdrWev4jEMBx?=
 =?us-ascii?q?7xKRR6JvjvGo7Vks+7y/2+94fcbglVmTaxe65+IAi3oAnetcQbhZZpJ7osxB?=
 =?us-ascii?q?fOvnZGYfldy3lyJVKUkRb858Ow84Bm/i9Npf8v9NNOXLvjcaggQrNWEDopM2?=
 =?us-ascii?q?Yu5M32rhbDVheA5mEdUmoNjBVFBRXO4QzgUZfwtiv6sfd92DWfMMbrQ704RS?=
 =?us-ascii?q?iu4qF2QxLzliwJKyA2/33WisxojaJUvhShpwBkw4XJZI2ZLedycr/Bcd8fQ2?=
 =?us-ascii?q?dOUNxRVyhcCY2iaYUBAfcKMeJBo4Xjo1YCqB2zDhSuCuzy0D9FnmL407M00+?=
 =?us-ascii?q?ohEg/I0gIvEN0Mv3vIo9v4L7sSXOKvwaXU0TnOYfFb1DHg44bIaBAhpvSMUK?=
 =?us-ascii?q?ptf8rN10YvDwPFgUuWqYf4Ij2V0/4Cs2yf7+V+VeOklmkqqxpsrTi03coslo?=
 =?us-ascii?q?nIiZ4VylDD7yl5xp01KseiRE50Zt6kDoJduieHPIV1WsMvW3xktSk1x7EcuZ?=
 =?us-ascii?q?O3YTIGxIooyhLBcfCLbo6F6Q/5WumLOzd3nndldaq6hxa17Eev1PXxVtKx0F?=
 =?us-ascii?q?ZWtipFlcTMtmwV2xzT9MeHTvx981+92TmVzQDT6/xEIVsumarHK58u3r4wlp?=
 =?us-ascii?q?0JvUTFAiD2g1n5gLWTdkUl/uik8+XnYrP4qZ+AL4J4lw7zP6s0lsG/HOg0KB?=
 =?us-ascii?q?YCUmeF9eimybHv5Uj5T69Ljv0ynKnZqpfaJcEDq66iHgBVyZ0u6wq/Dji60N?=
 =?us-ascii?q?QYmmMLLFReeB2dlYTpNFbOIO7gAfeln1usiCtrx+zBPrD5HprCMGXMkK3gfb?=
 =?us-ascii?q?lh8UJdxwszzdZQ559PC7EBJu7zVVH1tNDCEhA5NAm0yf79CNphzoMeRX6PAq?=
 =?us-ascii?q?iBPaPWrF+I+uUvLvKPZIALojb9LeYq5/r0gX8+g18dcrGj3YELZ3CgAvRmP0?=
 =?us-ascii?q?KZbGL3gtgfC2gKuBAyTO7whFKeUT5TfXeyX7kg5jE8EIKmDZnMRpq2gLyG2i?=
 =?us-ascii?q?e2BZxWZmZaCl+SFXfkbZmLW/AJaCiKOM9ujiQEVaS9S48mzRyuthX1y6BkLu?=
 =?us-ascii?q?rX/S0Ur4nj28J25+3QlBEy8yJ7D8KG3mGJTmF0mH4IRjAs0KB+p0x91kmM0a?=
 =?us-ascii?q?xij/NEEtxT4utDUh0mOp7E0+x6F9fyVxrDfteMT1amWM+mATAqTt8qxd8BeU?=
 =?us-ascii?q?N9FMujjhzZ2CqqGbAVnaSRBJMo6qLcw2TxJ8FlxnbdyqYhlVYmTdVUOG2mnK?=
 =?us-ascii?q?F/8wzTBo7Pk0mDi6mqcqEc1jbX9Gif1WqOoF1YUAloXKXBXHAfYFbWrNvg6k?=
 =?us-ascii?q?PZUbChFaknMhFAyc6eKqpGc9jpjVJbS/f+PNTRfXm8m3m/BRmW3LOAdonqdH?=
 =?us-ascii?q?sH3CXbFkcElxof/XGcNQgxHi2huX7RDCRyFVLzZEPh6fF+p2mmTk8w1AyKd1?=
 =?us-ascii?q?du16ex+hIMgPycTPQT3qgatys7tzp0G1O91crMC9WcvwphYLlcYdQl7VhZzW?=
 =?us-ascii?q?LWrRZ9Pp27L615nl4RaR53v0L11xVvDoVPi9Qlo20wwAp1M6KY30tLdymE0p?=
 =?us-ascii?q?DoJr3XNm7y8Qi0a6HI3lHe0dCW+roA6fkjtVXjsx+mFlA4/3VkzdZVyX2c6Y?=
 =?us-ascii?q?vODAYIVpLxSEk3/QBgp77Geik9+5/U1Xp0PKm2rDDCx9IpBPEiyhu7cddfN7?=
 =?us-ascii?q?mEFBPoHM0cBsivJ/YmlESubhIBJOpS7rI7P9u6d/ua366mJPtvkyi4jWtZ+o?=
 =?us-ascii?q?x90liD9yxnSuHW2ZYI2PCY3g2bVzjiiFetqNz4mYdBZTsKBGqw1TDkBJJNZq?=
 =?us-ascii?q?11ZYsLFWiuI8m4x9hlg57tWnhY9EO/B1Mc38+pfxuSblPn0QJNy0sduWanlj?=
 =?us-ascii?q?egzzxojzEpqbKS3CPUw+v8exoKIXBERG9gjVjyJYi0i9EaU1SyYwc1kxul4F?=
 =?us-ascii?q?7wx7JHq6RnM2nTXUBIcjDqL2FlSKuwqKCNY8pS55MzqihXVOW8YVaHSr/yuh?=
 =?us-ascii?q?ca3STjH3ZYxD8mbT6qppT5nxt8iG6HK3ZztnXZc9lqxRjD/NzcWeJR3j0eSS?=
 =?us-ascii?q?l8iDnXAEW8Ptaw8dWXiZjDqOa+WHylVpBIbynrwp2PtDGh6W1pHxK/hfazlc?=
 =?us-ascii?q?PjEQQg1i/7zdZqXz3SrBngeonry7i6MeV/c0hnB1Lx6tF3GoJgnYsqgpEfx3?=
 =?us-ascii?q?waio+S/Xodnmf5Kc9b1r7mbHoRWT4LxMbY4Azk2E1lM3KIyJv1Vm6SwspufN?=
 =?us-ascii?q?S6fGwW1Twn78xQC6eb8qZEnS1rrVq8tw7RZuJ9njgFw/s09HEam/0JuBYqzi?=
 =?us-ascii?q?iFGL8SHlFYPSn3mhSM7tC+qrhXZWm2fbi+00p+gNahA6yYrQFAWXb5fZEiET?=
 =?us-ascii?q?V37sVlP1LGyGfz5Z38eNnMcdITsQWZkxHAj+hSMpIxk+AFhSx8NGLno3Iq1u?=
 =?us-ascii?q?47ggZy3Z2goIeHLGBt9rqjAhFELj31e98T+jb1gKZYhsaW2pygEYl7FTUPWJ?=
 =?us-ascii?q?voUPeoHSkItfv5KgmOECczqmuBFbXDGg+f7V9sr2jTHJCzK3GXOH4ZwM15RB?=
 =?us-ascii?q?aDPkxfjx4bUC8gkZ85EQCq2crhfVx45jAX+l73tB9Mxvh0OBn4V2fVvB2oZS?=
 =?us-ascii?q?ssSJiDMBpW6RlP51zVMcOE7uN/BSJY8Ye9rA2MM2CaZh5HDWQIWkyeHF3jP7?=
 =?us-ascii?q?+u5cXe/OicHOaxM/zOYbCWo+xES/iI3Y6v0pdh/zuUNsWAJHhiD+Eh1UpER3?=
 =?us-ascii?q?x5G9nZlC8JSywYjC/NbsibpAui9S1ztMyw7PPrWAf374uVF7RSKclv+wyxga?=
 =?us-ascii?q?qbLeGQgjt2KSxZ1pIM33PI07gf00AMiy5ydzmiD7IAtS3KTK/Lnq9XDhgbaz?=
 =?us-ascii?q?58NcdS7qI82BVNNtDfit/vyrF4ifs1AU9fVVP9gsGpedAKI2alOVPEHkmLNa?=
 =?us-ascii?q?6KJSbVw87tYaO8T6ZdjORStx2spzmbF1XvMSiElznsTxqvK/1DjDmHPBxCv4?=
 =?us-ascii?q?Gwag1iCXD4Qd38bh27McF4jTs1zLEum3zFK3YWMSJgfENVsr2Q8SRYj+19G2?=
 =?us-ascii?q?xG9XplLfKJmySe7+nDKpYWreFrAiVsl+Je/ns616dV4DtDRPxvlyvYtsRurE?=
 =?us-ascii?q?2+kumT1jpnVwJDqjVRi4KKp0liObjZ+YNGWXbL5x8N7GOQCwgUqNthENHgp6?=
 =?us-ascii?q?dQyt3XnqLpNDhC687U/dcbB8XMMsKHMWQuMRz1GD7WEgQFViWmNW7Yh0xan/?=
 =?us-ascii?q?GS8mOaooImpZjrnZpdAoNcARYFF/UVTgxOEdAYIZw9FmcvnLKBjcVO9Xu4oz?=
 =?us-ascii?q?HQQtlXutbMUffERb3GLjqIxZ1ZexwNwKnjLoVbYonmx0tKaVRgmonOXU3KUo?=
 =?us-ascii?q?YJ6mdKbhU1u1lK6HhzVHY03QatUQ6k5jcxX7bghRM/jE18J+8t7jb3/1AvJl?=
 =?us-ascii?q?fQvyw2uEg3hdjhxzuWdWiiAr23WNRtFyfst0U3eqj+SgJxYBz6yVdoLx/YVr?=
 =?us-ascii?q?lRiP1mbmkthwjC78gcUcVARLFJNUdDjcqcYO8lhBEF8HSq?=
X-IPAS-Result: =?us-ascii?q?A2CUAACKD+hc/wHyM5BlGQEBAQEBAQEBAQEBAQcBAQEBA?=
 =?us-ascii?q?QGBZYFnKoE6ATIohBOTC0wBAQEDBoE1iU6PHoFnCQEBAQEBAQEBATQBAgEBh?=
 =?us-ascii?q?EACgj8jOBMBAwEBAQQBAQEBAwEBbCiCOikBgmYBAQEBAgEjBBEvEgULCxUBA?=
 =?us-ascii?q?gICIwMCAkYRBgEMBgIBAReCSD+BdwUPphl8M4VHgy6BRoEMKIs2HRd4gQeBE?=
 =?us-ascii?q?SeCaz6EEQERAgGDKIJYBIsvQYFohX+UcAmCD4ISkHoGG4FnglOOLINbjGiXe?=
 =?us-ascii?q?yFmcSsIAhgIIQ+DJ4IbF4ECAQKNNyMDMAGBBQEBizUlBoIlAQE?=
Received: from tarius.tycho.ncsc.mil ([144.51.242.1])
  by EMSM-GH1-UEA10.NCSC.MIL with ESMTP; 24 May 2019 15:41:34 +0000
Received: from moss-pluto.infosec.tycho.ncsc.mil (moss-pluto [192.168.25.131])
        by tarius.tycho.ncsc.mil (8.14.4/8.14.4) with ESMTP id x4OFfT42028992;
        Fri, 24 May 2019 11:41:29 -0400
Subject: Re: SGX vs LSM (Re: [PATCH v20 00/28] Intel SGX1 support)
To:     "Xing, Cedric" <cedric.xing@intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        "Christopherson, Sean J" <sean.j.christopherson@intel.com>
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        James Morris <jmorris@namei.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        LSM List <linux-security-module@vger.kernel.org>,
        Paul Moore <paul@paul-moore.com>,
        Eric Paris <eparis@parisplace.org>,
        "selinux@vger.kernel.org" <selinux@vger.kernel.org>,
        Jethro Beekman <jethro@fortanix.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Dr. Greg" <greg@enjellic.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "npmccallum@redhat.com" <npmccallum@redhat.com>,
        "Ayoun, Serge" <serge.ayoun@intel.com>,
        "Katz-zamir, Shay" <shay.katz-zamir@intel.com>,
        "Huang, Haitao" <haitao.huang@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "Svahn, Kai" <kai.svahn@intel.com>, Borislav Petkov <bp@alien8.de>,
        Josh Triplett <josh@joshtriplett.org>,
        "Huang, Kai" <kai.huang@intel.com>,
        David Rientjes <rientjes@google.com>
References: <20190521155140.GE22089@linux.intel.com>
 <20190522132022.GC31176@linux.intel.com>
 <20190522132227.GD31176@linux.intel.com>
 <0e183cce-c4b4-0e10-dbb6-bd81bea58b66@tycho.nsa.gov>
 <20190522153836.GA24833@linux.intel.com>
 <CALCETrUS8xyF1JJmQs18BGTDhPRXf+s81BkMZCZwmY73r7M+zg@mail.gmail.com>
 <20190523023517.GA31950@linux.intel.com>
 <20190523102628.GC10955@linux.intel.com>
 <20190523141752.GA12078@linux.intel.com>
 <CALCETrUzx3LPAKCLFf75P-XshAkRcr+JLET3LA_kHDs9MA11FA@mail.gmail.com>
 <20190523234044.GC12078@linux.intel.com>
 <CALCETrV4DVEfW6EJ6DnQGGYDJAiA5M1QcuYJTiroumOM+D6Jjg@mail.gmail.com>
 <960B34DE67B9E140824F1DCDEC400C0F654E8956@ORSMSX116.amr.corp.intel.com>
From:   Stephen Smalley <sds@tycho.nsa.gov>
Message-ID: <dda0912b-cb15-3c07-d368-345159e995f7@tycho.nsa.gov>
Date:   Fri, 24 May 2019 11:41:29 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <960B34DE67B9E140824F1DCDEC400C0F654E8956@ORSMSX116.amr.corp.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On 5/24/19 3:24 AM, Xing, Cedric wrote:
> Hi Andy,
> 
>> From: Andy Lutomirski [mailto:luto@kernel.org]
>> Sent: Thursday, May 23, 2019 6:18 PM
>>
>> On Thu, May 23, 2019 at 4:40 PM Sean Christopherson <sean.j.christopherson@intel.com>
>> wrote:
>>>
>>> On Thu, May 23, 2019 at 08:38:17AM -0700, Andy Lutomirski wrote:
>>>> On Thu, May 23, 2019 at 7:17 AM Sean Christopherson
>>>> <sean.j.christopherson@intel.com> wrote:
>>>>>
>>>>> On Thu, May 23, 2019 at 01:26:28PM +0300, Jarkko Sakkinen wrote:
>>>>>> On Wed, May 22, 2019 at 07:35:17PM -0700, Sean Christopherson wrote:
>>>>>>> But actually, there's no need to disallow mmap() after ECREATE
>>>>>>> since the LSM checks also apply to mmap(), e.g. FILE__EXECUTE
>>>>>>> would be needed to
>>>>>>> mmap() any enclave pages PROT_EXEC.  I guess my past self
>>>>>>> thought mmap() bypassed LSM checks?  The real problem is that
>>>>>>> mmap()'ng an existing enclave would require FILE__WRITE and
>>>>>>> FILE__EXECUTE, which puts us back at square one.
>>>>>>
>>>>>> I'm lost with the constraints we want to set.
>>>>>
>>>>> As is today, SELinux policies would require enclave loaders to
>>>>> have FILE__WRITE and FILE__EXECUTE permissions on
>>>>> /dev/sgx/enclave.  Presumably other LSMs have similar
>>>>> requirements.  Requiring all processes to have
>>>>> FILE__{WRITE,EXECUTE} permissions means the permissions don't add
>>>>> much value, e.g. they can't be used to distinguish between an
>>>>> enclave that is being loaded from an unmodified file and an enclave that is being
>> generated on the fly, e.g. Graphene.
>>>>>
>>>>> Looking back at Andy's mail, he was talking about requiring
>>>>> FILE__EXECUTE to run an enclave, so perhaps it's only FILE__WRITE
>>>>> that we're trying to special case.
>>>>>
>>>>
>>>> I thought about this some more, and I have a new proposal that helps
>>>> address the ELRANGE alignment issue and the permission issue at the
>>>> cost of some extra verbosity.  Maybe you all can poke holes in it :)
>>>> The basic idea is to make everything more explicit from a user's
>>>> perspective.  Here's how it works:
>>>>
>>>> Opening /dev/sgx/enclave gives an enclave_fd that, by design,
>>>> doesn't give EXECUTE or WRITE.  mmap() on the enclave_fd only works
>>>> if you pass PROT_NONE and gives the correct alignment.  The
>>>> resulting VMA cannot be mprotected or mremapped.  It can't be
>>>> mmapped at all until
>>>
>>> I assume you're thinking of clearing all VM_MAY* flags in sgx_mmap()?
>>>
>>>> after ECREATE because the alignment isn't known before that.
>>>
>>> I don't follow.  The alignment is known because userspace knows the
>>> size of its enclave.  The initial unknown is the address, but that
>>> becomes known once the initial mmap() completes.
>>
>> [...]
>>
>> I think I made the mistake of getting too carried away with implementation details rather
>> than just getting to the point.  And I misremembered the ECREATE flow -- oops.  Let me try
>> again.  First, here are some problems with some earlier proposals (mine, yours
>> Cedric's):
>>
>>   - Having the EADD operation always work but have different effects depending on the
>> source memory permissions is, at the very least, confusing.
> 
> Inheriting permissions from source pages IMHO is the easiest way to validate the EPC permissions without any changes to LSM. And the argument about its security is also easy to make.
> 
> I understand that it may take some effort to document it properly but otherwise don't see any practical issues with it.
> 
>>
>>   - If we want to encourage user programs to be well-behaved, we want to make it easy to
>> map the RX parts of an enclave RX, the RW parts RW, the RO parts R, etc.  But this
>> interacts poorly with the sgx_mmap() alignment magic, as you've pointed out.
>>
>>   - We don't want to couple LSMs with SGX too tightly.
>>
>> So here's how a nice interface might work:
>>
>> int enclave_fd = open("/dev/sgx/enclave", O_RDWR);
>>
>> /* enclave_fd points to a totally blank enclave. Before ECREATE, we need to decide on an
>> address. */
>>
>> void *addr = mmap(NULL, size, PROT_NONE, MAP_SHARED, enclave_fd, 0);
>>
>> /* we have an address! */
>>
>> ioctl(enclave_fd, ECREATE, ...);
>>
>> /* now add some data to the enclave.  We want the RWX addition to fail
>> immediately unless we have the relevant LSM pemission.   Similarly, we
>> want the RX addition to fail immediately unless the source VMA is appropriate. */
>>
>> ioctl(enclave_fd, EADD, rx_source_1, MAXPERM=RX, ...);  [the ...
>> includes SECINFO, which the kernel doesn't really care about] ioctl(enclave_fd, EADD,
>> ro_source_1, MAXPERM=RX ...); ioctl(enclave_fd, EADD, rw_source_1, MAXPERM=RW ...);
>> ioctl(enclave_fd, EADD, rwx_source_1, MAXPERM=RWX ...);
> 
> If MAXPERM is taken from ioctl parameters, the real question here is how to validate MAXPERM. Guess we shouldn't allow arbitrary MAXPERM to be specified by user code, and the only logical source I can think of is from the source pages (or from the enclave source file, but memory mapping is preferred because it offers more flexibility).
>   
>>
>> ioctl(enclave_fd, EINIT, ...);  /* presumably pass sigstruct_fd here, too. */
>>
>> /* at this point, all is well except that the enclave is mapped PROT_NONE. There are a
>> couple ways I can imagine to fix this. */
>>
>> We could use mmap:
>>
>> mmap(baseaddr+offset, len, PROT_READ, MAP_SHARED | MAP_FIXED, enclave_fd, 0);  /* only
>> succeeds if MAXPERM & R == R */
>>
>> But this has some annoying implications with regard to sgx_get_unmapped_area().  We could
>> use an ioctl:
> 
> There's an easy fix. Just let sgx_get_unmapped_area() do the natural alignment only if MAP_FIXED is *not* set, otherwise, honor both address and len.
> 
> But mmap() is subject to LSM check (probably against /dev/sgx/enclave?). How to do mmap(RX) if FILE__EXECUTE is *not* granted for /dev/sgx/enclave, even if MAXPERM=RX?
> 
>>
>> ioctl(enclave_fd, SGX_IOC_MPROTECT, offset, len, PROT_READ);
>>
>> which has the potentially nice property that we can completely bypass the LSM hooks,
>> because the LSM has *already* vetted everything when the EADD calls were allowed.  Or we
>> could maybe even just use
>> mprotect() itself:
>>
>> mprotect(baseaddr + offset, len, PROT_READ);
> 
> How to bypass LSM hooks in this mprotect()?
> 
>>
>> Or, for the really evil option, we could use a bit of magic in .fault and do nothing here.
>> Instead we'd make the initial mapping PROT_READ|PROT_WRITE|PROT_EXEC and have .fault
>> actually instantiate the PTEs with the intersection of the VMA permissions and MAXPERM.  I
>> don't think I like this alternative, since it feels more magical than needed and it will
>> be harder to debug.  I like the fact that /proc/self/maps shows the actual permissions in
>> all the other variants.
> 
> Agreed.
>   
>>
>>
>> All of the rest of the crud in my earlier email was just implementation details.  The
>> point I was trying to make was that I think it's possible to implement this without making
>> too much of a mess internally.  I think I favor the mprotect() approach since it makes the
>> behavior fairly obvious.
>>
>> I don't think any of this needs to change for SGX2.  We'd have an
>> ioctl() that does EAUG and specifies MAXPERM.  Trying to mprotect() a page that hasn't
>> been added yet with any permission other than PROT_NONE would fail.  I suppose we might
>> end up needing a way to let the EAUG operation *change* MAXPERM, and this operation would
>> have to do some more LSM checks and walk all the existing mappings to make sure they're
>> consistent with the new MAXPERM.
> 
> EAUG ioctl could be a solution, but isn't optimal at least. What we've done is #PF based. Specifically, an SGX2 enclave will have its heap mapped as RW, but without any pages populated before EINIT. Then when the enclave needs a new page in its heap, it issues EACCEPT, which will cause a #PF and the driver will respond by EAUG a new EPC page. And then the enclave will be resumed and the faulted EACCEPT will be retried (and succeed).
> 
>>
>> As an aside, I wonder if Linus et all would be okay with a new MAP_FULLY_ALIGNED mmap()
>> flag that allocated memory aligned to the requested size.  Then we could get rid of yet
>> another bit of magic.
>>
>> --Andy
> 
> I've also got a chance to think more about it lately.
> 
> When we talk about EPC page permissions with SGX2 in mind, I think we should distinguish between initial permissions and runtime permissions. Initial permissions refer to the page permissions set at EADD. They are technically set by "untrusted" code so should go by policies similar to those applicable to regular shared objects. Runtime permissions refer to the permissions granted by EMODPE, EAUG and EACCEPTCOPY. They are resulted from inherent behavior of the enclave, which in theory is determined by the enclave's measurements (MRENCLAVE and/or MRSIGNER).
> 
> And we have 2 distinct files to work with - the enclave file and /dev/sgx/enclave. And I consider the enclave file a logical source for initial permissions while /dev/sgx/enclave is a means to control runtime permissions. Then we can have a simpler approach like the pseudo code below.
> 
> /**
>   * Summary:
>   * - The enclave file resembles a shared object that contains RO/RX/RW segments
>   * - FILE__* are assigned to /dev/sgx/enclave, to determine acceptable permissions to mmap()/mprotect(), valid combinations are
>   *   + FILE__READ - Allow SGX1 enclaves only
>   *   + FILE__READ|FILE__WRITE - Allow SGX2 enclaves to expand data segments (e.g. heaps, stacks, etc.)
>   *   + FILE__READ|FILE__WRITE|FILE__EXECUTE - Allow SGX2 enclaves to expend both data and code segments. This is necessary to support dynamically linked enclaves (e.g. Graphene)
>   *   + FILE__READ|FILE__EXECUTE - Allow RW->RX changes for SGX1 enclaves - necessary to support dynamically linked enclaves (e.g. Graphene) on SGX1. EXECMEM is also required for this to work

I think EXECMOD would fit better than EXECMEM for this case; the former 
is applied for RW->RX changes for private file mappings while the latter 
is applied for WX private file mappings.

>   *   + <None> - Disallow the calling process to launch any enclaves
>   */
> 
> /* Step 1: mmap() the enclave file according to the segment attributes (similar to what dlopen() would do for regular shared objects) */
> int image_fd = open("/path/to/enclave/file", O_RDONLY);

FILE__READ checked to enclave file upon open().

> foreach phdr in loadable segments /* phdr->p_type == PT_LOAD */ {
>      /* <segment permission> below is subject to LSM checks */
>      loadable_segments[i] = mmap(NULL, phdr->p_memsz, MAP_PRIATE, <segment permission>, image_fd, phdr->p_offset);

FILE__READ revalidated and FILE__EXECUTE checked to enclave file upon 
mmap() for PROT_READ and PROT_EXEC respectively.  FILE__WRITE not 
checked even for PROT_WRITE mappings since it is a private file mapping 
and writes do not reach the file.  EXECMEM checked if any segment 
permission has both W and X simultaneously.  EXECMOD checked on any 
subsequent mprotect() RW->RX changes (if modified).

> }
> 
> /* Step 2: Create enclave */
> int enclave_fd = open("/dev/sgx/enclave", O_RDONLY /* or O_RDWR for SGX2 enclaves */);

FILE__READ checked (SGX1) or both FILE__READ and FILE__WRITE checked 
(SGX2) to /dev/sgx/enclave upon open().  Assuming that we are returning 
an open file referencing the /dev/sgx/enclave inode and not an anon 
inode, else we lose all subsequent FILE__* checking on mmap/mprotect and 
trigger EXECMEM on any mmap/mprotect PROT_EXEC.

> void *enclave_base = mmap(NULL, <enclave size>, MAP_SHARED, PROT_READ, enclave_fd, 0); /* Only FILE__READ is required here */

FILE__READ revalidated to /dev/sgx/enclave upon mmap().

> ioctl(enclave_fd, IOC_ECREATE, ...);
> 
> /* Step 3: EADD and map initial EPC pages */
> foreach s in loadable_segments {
>      /* IOC_EADD_AND_MAP_SEGMENT will make sure s->perm is a subset of VMA permissions of the source pages, and use that as *both* EPCM and VMA permissions).
>       * Given enclave_fd may have FILE__READ only, LSM has to be bypassed so the "mmap" part has to be done inside the driver.
>       * Initial EPC pages will be mapped only once, so no inode is needed to remember the initial permissions. mmap/mprotect afterwards are subject to FILE__* on /dev/sgx/enclave
>       * The key point here is: permissions of source pages govern initial permissions of EADD'ed pages, regardless FILE__* on /dev/sgx/enclave
>       */
>      ioctl(enclave_fd, IOC_EADD_AND_MAP_SEGMENT, s->base, s->size, s->perm...);
> }
> /* EADD other enclave components, e.g. TCS, stacks, heaps, etc. */
> ioctl(enclave_fd, IOC_EADD_AND_MAP_SEGMENT, tcs, 0x1000, RW | PT_TCS...);
> ioctl(enclave_fd, IOC_EADD_AND_MAP_SEGMENT, <zero page>, <stack size>, RW...);
> ...
> 
> /* Step 4 (SGX2 only): Reserve ranges for additional heaps, stacks, etc. */
> /* FILE__WRITE required to allow expansion of data segments at runtime */
> /* Key point here is: permissions, if needed to change at runtime, are subject to FILL__* on /dev/sgx/enclave */
> mprotect(<heap address>, <heap size>, PROT_READ | PROT_WRITE);

FILE__READ and FILE__WRITE revalidated to /dev/sgx/enclave upon mprotect().

> 
> /* Step 5: EINIT */
> ioctl(IOC_EINIT, <sigstruct>...);
> 
> /* Step 6 (SGX2 only): Set RX for dynamically loaded code pages (e.g. Graphene, encrypted enclaves, etc.) as needed, at runtime */
> /* FILE__EXECUTE required */
> mprotect(<RX address>, <RX size>, PROT_READ | PROT_EXEC);

FILE__READ revalidated and FILE__EXECUTE checked to /dev/sgx/enclave 
upon mprotect().  Cumulative set of checks at this point is 
FILE__READ|FILE__WRITE|FILE__EXECUTE.

What would the step be for a SGX1 RW->RX change?  How would that trigger 
EXECMOD?  Do we really need to distinguish it from the SGX2 dynamically 
loaded code case?

> 
> -Cedric
> 

