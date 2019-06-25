Return-Path: <SRS0=BFWe=UY=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D94DC48BD5
	for <linux-sgx@archiver.kernel.org>; Tue, 25 Jun 2019 21:49:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 133172086D
	for <linux-sgx@archiver.kernel.org>; Tue, 25 Jun 2019 21:49:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=tycho.nsa.gov header.i=@tycho.nsa.gov header.b="ZdWNBnY6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726274AbfFYVtM (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 25 Jun 2019 17:49:12 -0400
Received: from upbd19pa10.eemsg.mail.mil ([214.24.27.85]:23322 "EHLO
        upbd19pa10.eemsg.mail.mil" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726037AbfFYVtM (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Tue, 25 Jun 2019 17:49:12 -0400
X-EEMSG-check-017: 235578013|UPBD19PA10_EEMSG_MP10.csd.disa.mil
Received: from emsm-gh1-uea11.ncsc.mil ([214.29.60.3])
  by upbd19pa10.eemsg.mail.mil with ESMTP/TLS/DHE-RSA-AES256-SHA256; 25 Jun 2019 21:49:06 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=tycho.nsa.gov; i=@tycho.nsa.gov; q=dns/txt;
  s=tycho.nsa.gov; t=1561499347; x=1593035347;
  h=subject:from:to:cc:references:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=NYCXJEe+VXIlGVHAD1ccb1GJ/X3waK5j6q6L8PKPaNI=;
  b=ZdWNBnY6pbKockEG5SAK2+TntuQhqLvh0c25nyK6qfdu0TpI9R3DVjPk
   lzKSrm7o6BnnHVOLqqHqpogkxfRcJ2sk8/kMktpnydvm9KLHKWCLVTIlR
   v2FNPwTX51m+Epd34rXqQpkCdhosCOeGNRyeOx9y3AmZrwaDzgZnSXNAc
   Kk++Oa4WwL/kvpZpv6jKr/YI4bgP8ibF5DpxY+3H465Cg4IW0888WaYD9
   Ff66J9/w0uPgOeYv3McR+rbUmRCt9uRSR9FMjgy3gGCFImOCX8hr5i/IB
   +Y2WPZuJO7MMD13WB6wUYRXXfRSt9GGU/Cnv23NMFjXBujL1KtJVh+Ivx
   Q==;
X-IronPort-AV: E=Sophos;i="5.63,417,1557187200"; 
   d="scan'208";a="29421814"
IronPort-PHdr: =?us-ascii?q?9a23=3AeyEnvR3AtUpaOZqYsmDT+DRfVm0co7zxezQtwd?=
 =?us-ascii?q?8ZsesRKP7xwZ3uMQTl6Ol3ixeRBMOHsqgC0rad6vqwESxYuNDd6SlEKMQNHz?=
 =?us-ascii?q?Y+yuwu1zQ6B8CEDUCpZNXLVAcdWPp4aVl+4nugOlJUEsutL3fbo3m18CJAUk?=
 =?us-ascii?q?6nbVk9Kev6AJPdgNqq3O6u5ZLTfx9IhD2gar9uMRm6twrcutQIjYd4N6o8xR?=
 =?us-ascii?q?TFrmZWd+lV2GhkIU6fkwvm6sq/4ZJv7j5ct+49+8JFTK73Y7k2QbtEATo8Lm?=
 =?us-ascii?q?s7/tfrtR7NTQuO4nsTTGAbmQdWDgbG8R/3QI7/vjP1ueRh1iaaO9b2Ta0vVj?=
 =?us-ascii?q?S586hrUh7ohzwZODM/7Wral9Z/jKNfoBKmuhx/34vZa5ybOfZiYq/Qe84RSH?=
 =?us-ascii?q?FfVchNSSNOHoK8b5MOD+UfO+ZYs5L9rEYKoRenGAWgGP/jxjpOi3D4x6061/?=
 =?us-ascii?q?kqHx/A0gIuAtkCtG3YodXxOasXV+2+0avGwijZb/5OxDnz6JbGch4ir/+CU7?=
 =?us-ascii?q?1/fsjexlUgGQ7eklWdqpboMy+J2ukDsWWW6fdrW+K1i24grgF8uiWhxtsyhY?=
 =?us-ascii?q?nRhoIa1FbE/jhkzoYwP9K4TEp7bsCkEZBNsCyaLJZ5Qtg5TmF0uCc11r0GuZ?=
 =?us-ascii?q?mhcCgM05Qo3QTTa/OAc4iW+x/uUvuaLzRghH99Zb6yiBm//VKgx+HhTMW4zl?=
 =?us-ascii?q?lHojRfntXRsH0Gygbd5dKdSvRn+0eswTOP1wfO5e5aOU00jq/bK4I5wr43i5?=
 =?us-ascii?q?oTrVzPHi/ol0Xyi6+bblkk9fKy6+Tmf7XmvYWQN5N0iw7iMqQundazAeIkPQ?=
 =?us-ascii?q?gVQ2eX4+G81Lzn/UHhQbVKiOM5krXBvZzHKskWqbS1Dg9I3oo59RqyACmq3M?=
 =?us-ascii?q?4FkXUfKVJKYhOHj4znO1HUJ/D4CO+yg0+xnzdw3P3GIr3gDYnNLnjEirvhe6?=
 =?us-ascii?q?195FRGxAo8ytBf+YpYCqsdL/LrRk/xqNvYAwclPAOq3unnEtR92Z8EVWOAA6?=
 =?us-ascii?q?+ZNqzSvESJ5uIpP+mDeosVtCzhJPgi4v7klWU5lkMFfam1wZsXb2i1Hu94LE?=
 =?us-ascii?q?qDZ3rgmNUBHX0WsQo+VuzqiUaCUSJUZ3aqX6Iz+Cs7CJmhDYfFXY2tgbqB3D?=
 =?us-ascii?q?ulEZ1SfGxJFleMEXLwfYWeR/gMcD6SItNmkjEcV7iuUZUh1RKttA/90bZnNf?=
 =?us-ascii?q?Db+i4btZLi0th6+evTmAo29Tx1CcSdzm6MQ3t1nmMOWz85wqR/rVZhxVeE1K?=
 =?us-ascii?q?hym+ZYGsBL5/NVTgc6MobRz+h7C9D0RwLAcc6FSE2pQtSpGjwxUN0xzMEUY0?=
 =?us-ascii?q?pnGNWtkArD3yy0DL8RjbCLA4Y08q3E1XjrO8l902rG1LUmj1Q+RstPNGumhr?=
 =?us-ascii?q?Nw9gTKHI7GjVmWl7uwdaQdwC7M9H6PzW+JvE5FTQ5wVbvKUGsBZkvZs9v5/F?=
 =?us-ascii?q?nOT7ywBrQ9NAtO18qCJrFNat3zglVMXO3jN8jGY2Kth2ewAg6FxqiSY4ruem?=
 =?us-ascii?q?Ud2jjdCUcfngAN8naJKxI+Cj2io23AFjxuE0zgY0f2/el5snO7QVc+zxuWYE?=
 =?us-ascii?q?15y7q15hkViOSSSvMS2rIEvCYhpC9xHFqnw93aEcCApw16c6pCe9M9/ExH2H?=
 =?us-ascii?q?nYtwx7IpyvMaRiikQCfARwukPkzw93BZlYkcg2sHMqyxJ/Jr6C31NaaTyZ3Y?=
 =?us-ascii?q?r8OqbLJWny5h+vdqDW2lXA39aM4aoP6fI4q0n9swGtDEYt73Jn09xN2XuG+p?=
 =?us-ascii?q?rKFBYSUY72Uksv9Rh6orbaYjMn54PVzn1hKq+0vSXH2903Besp0BGgf81QMK?=
 =?us-ascii?q?mcDg/9D9UaB9SyKOwtg1WmcwgLPP5M+6IuP8Opbf2G2LW1M+Zmhz+mjGJH4J?=
 =?us-ascii?q?xj3UKI7SZzVunI35MdyfGCwgSHTyv8jEumss3vnYBEeC0SHm2kxCjnGoFRfK?=
 =?us-ascii?q?tycpgPCWu0JM233Np+jYb3W3FE7F6jG08G2MixdBqQcVP9wQ1Q1V4QoXG8ly?=
 =?us-ascii?q?u4yCZ0ky0zoaqZ3SzPzP7uewYAOm5OXGNil0vjIZCoj9AGW0ildwcplAG76k?=
 =?us-ascii?q?b13KVUuqJ/L2vNTkdMeyj2Ln1tXrGsubqFZs4coK8v5G9nUeKzJRixR7Lnoh?=
 =?us-ascii?q?BQm3foEmdExTt9ZzCstb34mQB3jCSWK3Ml6DKTUsFqxAzD48TcSORK2TxCDB?=
 =?us-ascii?q?J1gD+fJBL0a8Kk9NPSldHIsvq/TH6mTp1eazLsy6uBsje24SthBhjp27iRk8?=
 =?us-ascii?q?fkEg9y6ib41NhsWCOA+BT1eIro0OKhOOFkf09lAnf46sxnCsd/lJc9gNcb3n?=
 =?us-ascii?q?1M1buP+n9Sqnv+KdVW3+rFaXMJQTMai4rO7BPNxFxoLnXPwZnwEHqa3J0yNJ?=
 =?us-ascii?q?GBfmoK13dlvIhxA6CO4ekBxHYkrw=3D=3D?=
X-IPAS-Result: =?us-ascii?q?A2ASAAB7lhJd/wHyM5BlGgEBAQEBAgEBAQEHAgEBAQGBV?=
 =?us-ascii?q?gIBAQEBCwGBbCqBPDKEPZJ5TQEBAQEBAQaBESWJU5EOCQEBAQEBAQEBATQBA?=
 =?us-ascii?q?gEBhEACgnUjNwYOAQMBAQEEAQEBAQQBAWyKQ4I6KQGCZgEBAQEDIwQLAQVBE?=
 =?us-ascii?q?AkCFQECAgImAgJXBgEMCAEBgl8/gXcUiW6ban4ziHGBRoEMKAGLXRd4gQeBO?=
 =?us-ascii?q?AyCXz6HToJYBI4hm3MJgheCHpFHBhuXTi2Me5kcIoFYKwgCGAghD4MogkwXF?=
 =?us-ascii?q?I4oIwOBNgEBj1wBAQ?=
Received: from tarius.tycho.ncsc.mil ([144.51.242.1])
  by emsm-gh1-uea11.NCSC.MIL with ESMTP; 25 Jun 2019 21:49:05 +0000
Received: from moss-pluto.infosec.tycho.ncsc.mil (moss-pluto [192.168.25.131])
        by tarius.tycho.ncsc.mil (8.14.4/8.14.4) with ESMTP id x5PLn2Qa008381;
        Tue, 25 Jun 2019 17:49:03 -0400
Subject: Re: [RFC PATCH v4 09/12] LSM: x86/sgx: Introduce ->enclave_load()
 hook for Intel SGX
From:   Stephen Smalley <sds@tycho.nsa.gov>
To:     "Xing, Cedric" <cedric.xing@intel.com>,
        "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "linux-security-module@vger.kernel.org" 
        <linux-security-module@vger.kernel.org>,
        "selinux@vger.kernel.org" <selinux@vger.kernel.org>,
        "Roberts, William C" <william.c.roberts@intel.com>,
        "Schaufler, Casey" <casey.schaufler@intel.com>,
        James Morris <jmorris@namei.org>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Jethro Beekman <jethro@fortanix.com>,
        "Dr . Greg Wettstein" <greg@enjellic.com>
References: <20190619222401.14942-1-sean.j.christopherson@intel.com>
 <20190619222401.14942-10-sean.j.christopherson@intel.com>
 <960B34DE67B9E140824F1DCDEC400C0F655184A2@ORSMSX116.amr.corp.intel.com>
 <008635cd-9c0b-1367-d250-99aa16b41305@tycho.nsa.gov>
Message-ID: <a494b094-cde7-b53d-3903-81ccc907b392@tycho.nsa.gov>
Date:   Tue, 25 Jun 2019 17:49:02 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <008635cd-9c0b-1367-d250-99aa16b41305@tycho.nsa.gov>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On 6/25/19 5:01 PM, Stephen Smalley wrote:
> On 6/21/19 1:05 PM, Xing, Cedric wrote:
>>> From: Christopherson, Sean J
>>> Sent: Wednesday, June 19, 2019 3:24 PM
>>>
>>> diff --git a/include/linux/security.h b/include/linux/security.h
>>> index 6a1f54ba6794..572ddfc53039 100644
>>> --- a/include/linux/security.h
>>> +++ b/include/linux/security.h
>>> @@ -1832,11 +1832,18 @@ static inline void 
>>> security_bpf_prog_free(struct bpf_prog_aux *aux)
>>>   #ifdef CONFIG_INTEL_SGX
>>>   #ifdef CONFIG_SECURITY
>>>   int security_enclave_map(unsigned long prot);
>>> +int security_enclave_load(struct vm_area_struct *vma, unsigned long 
>>> prot,
>>> +              bool measured);
>>>   #else
>>>   static inline int security_enclave_map(unsigned long prot)
>>>   {
>>>       return 0;
>>>   }
>>> +static inline int security_enclave_load(struct vm_area_struct *vma,
>>> +                    unsigned long prot, bool measured)
>>> +{
>>> +    return 0;
>>> +}
>>>   #endif /* CONFIG_SECURITY */
>>>   #endif /* CONFIG_INTEL_SGX */
>>
>> Parameters to security_enclave_load() are specific on what's being 
>> loading only, but unspecific on which enclave to be loaded into. That 
>> kills the possibility of an LSM module making enclave dependent 
>> decisions.
>>
>> Btw, if enclave (in the form of struct file) is also passed in as a 
>> parameter, it'd let LSM know that file is an enclave, hence would be 
>> able to make the same decision in security_mmap_file() as in 
>> security_enclave_map(). In other words, you wouldn't need 
>> security_enclave_map().
> 
> Sorry, you want security_enclave_load() to stash a reference to the 
> enclave file in some security module-internal state, then match it upon 
> later security_mmap_file() calls to determine that it is dealing with an 
> enclave, and then adjust its logic accordingly?  When do we release that 
> reference?

I guess you mean set a flag in the enclave file security struct upon 
security_enclave_load() and check that flag in security_mmap_file().

This seems somewhat similar to one of Sean's alternatives in the patch 
description for 06/12, except by pushing the information from sgx to LSM 
upon security_enclave_load() rather than pulling it via a 
is_sgx_enclave() helper.  Not clear if it is still subject to the same 
limitations.
