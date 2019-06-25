Return-Path: <SRS0=BFWe=UY=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CB8BC48BD6
	for <linux-sgx@archiver.kernel.org>; Tue, 25 Jun 2019 21:01:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E355720663
	for <linux-sgx@archiver.kernel.org>; Tue, 25 Jun 2019 21:01:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=tycho.nsa.gov header.i=@tycho.nsa.gov header.b="A5VoM7dm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726418AbfFYVBZ (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 25 Jun 2019 17:01:25 -0400
Received: from ucol19pa14.eemsg.mail.mil ([214.24.24.87]:38485 "EHLO
        ucol19pa14.eemsg.mail.mil" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726009AbfFYVBZ (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Tue, 25 Jun 2019 17:01:25 -0400
X-EEMSG-check-017: 719704193|UCOL19PA14_EEMSG_MP12.csd.disa.mil
X-IronPort-AV: E=Sophos;i="5.63,417,1557187200"; 
   d="scan'208";a="719704193"
Received: from emsm-gh1-uea10.ncsc.mil ([214.29.60.2])
  by ucol19pa14.eemsg.mail.mil with ESMTP/TLS/DHE-RSA-AES256-SHA256; 25 Jun 2019 21:01:18 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=tycho.nsa.gov; i=@tycho.nsa.gov; q=dns/txt;
  s=tycho.nsa.gov; t=1561496479; x=1593032479;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=iU2SWSBgIY5K6SLyWp+F0byH6zO+EGJZ+VWXWwssgas=;
  b=A5VoM7dmIDMWq+8m1OpjuC59yJ4w3YOKOHZBzz2yQTXiRLH1I0O9q0Cp
   DRZWWbvts7v07zSWdEoS69Gmec5d42bdgKVk7kzlf+unIGuyrjtqJ5YyH
   2V3B4/WmTmf/mDqGazykvDINgf3bZlo7/lktmsB6U4CCvKp5yQ1VdQrRM
   VjRgIUs1nOWoolpNt5AQSm8MK3ZqHGtCS26OamRARGAqTWQakUiXNm/uU
   BpZ+1JZfIr/DlxQthvvxJaQzsiSc7EIAzVtHx1i6XmJx4JC12nmsyJ44/
   gU+/plY6+NFabPIif3oWGbWrMD7DG0RBu8yZpDaYgy8WgU10lQvl4rBW1
   g==;
X-IronPort-AV: E=Sophos;i="5.63,417,1557187200"; 
   d="scan'208";a="25113501"
IronPort-PHdr: =?us-ascii?q?9a23=3A/2C4wB2hwTwEcT4ssmDT+DRfVm0co7zxezQtwd?=
 =?us-ascii?q?8ZsesRKP7xwZ3uMQTl6Ol3ixeRBMOHsqgC0rad6vqwESxYuNDd6SlEKMQNHz?=
 =?us-ascii?q?Y+yuwu1zQ6B8CEDUCpZNXLVAcdWPp4aVl+4nugOlJUEsutL3fbo3m18CJAUk?=
 =?us-ascii?q?6nbVk9Kev6AJPdgNqq3O6u5ZLTfx9IhD2gar9uMRm6twrcutQIjYd4N6o8xR?=
 =?us-ascii?q?TFrmZWd+lV2GhkIU6fkwvm6sq/4ZJv7j5ct+49+8JFTK73Y7k2QbtEATo8Lm?=
 =?us-ascii?q?s7/tfrtR7NTQuO4nsTTGAbmQdWDgbG8R/3QI7/vjP1ueRh1iaaO9b2Ta0vVj?=
 =?us-ascii?q?S586hrUh7ohzwZODM/7Wral9Z/jKNfoBKmuhx/34vZa5ybOfZiYq/Qe84RSH?=
 =?us-ascii?q?FfVchNSSNOHoK8b5MOD+UfO+ZYs5L9rEYKoRenGAWgGP/jxjpOi3D4x6061/?=
 =?us-ascii?q?kqHx/A0gIuAtkCtG3YodXxOasXV+2+0avGwijZb/5OxDnz9obIfBAir/+CU7?=
 =?us-ascii?q?1/fsjexlUgGQ7eklWdq5boMy+J2ukDsWWW6fdrW+K1i24grgF8uiWhxtsyhY?=
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
X-IPAS-Result: =?us-ascii?q?A2BOAAD2ihJd/wHyM5BlGgEBAQEBAgEBAQEHAgEBAQGBZ?=
 =?us-ascii?q?4FtKoE8MoQ9knlNAQEBAQEBBoERJYlTkQ4JAQEBAQEBAQEBNAECAQGEQAKCd?=
 =?us-ascii?q?SM4EwEDAQEBBAEBAQEEAQFsikOCOikBgmYBAQEBAyMEEUEQCxUBAgICJgICV?=
 =?us-ascii?q?wYBDAgBAYJfP4F3FKV4fjOFR4MqgUaBDCiLXhd4gQeBOAyCXz6HToJYBI4hh?=
 =?us-ascii?q?iaVTQmCF4IekUcGG5dOLYx7mR0hgVgrCAIYCCEPgyiCTBcUjigjA4E2AQGPX?=
 =?us-ascii?q?AEB?=
Received: from tarius.tycho.ncsc.mil ([144.51.242.1])
  by EMSM-GH1-UEA10.NCSC.MIL with ESMTP; 25 Jun 2019 21:01:18 +0000
Received: from moss-pluto.infosec.tycho.ncsc.mil (moss-pluto [192.168.25.131])
        by tarius.tycho.ncsc.mil (8.14.4/8.14.4) with ESMTP id x5PL1GVn021315;
        Tue, 25 Jun 2019 17:01:17 -0400
Subject: Re: [RFC PATCH v4 09/12] LSM: x86/sgx: Introduce ->enclave_load()
 hook for Intel SGX
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
From:   Stephen Smalley <sds@tycho.nsa.gov>
Message-ID: <008635cd-9c0b-1367-d250-99aa16b41305@tycho.nsa.gov>
Date:   Tue, 25 Jun 2019 17:01:16 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <960B34DE67B9E140824F1DCDEC400C0F655184A2@ORSMSX116.amr.corp.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On 6/21/19 1:05 PM, Xing, Cedric wrote:
>> From: Christopherson, Sean J
>> Sent: Wednesday, June 19, 2019 3:24 PM
>>
>> diff --git a/include/linux/security.h b/include/linux/security.h
>> index 6a1f54ba6794..572ddfc53039 100644
>> --- a/include/linux/security.h
>> +++ b/include/linux/security.h
>> @@ -1832,11 +1832,18 @@ static inline void security_bpf_prog_free(struct bpf_prog_aux *aux)
>>   #ifdef CONFIG_INTEL_SGX
>>   #ifdef CONFIG_SECURITY
>>   int security_enclave_map(unsigned long prot);
>> +int security_enclave_load(struct vm_area_struct *vma, unsigned long prot,
>> +			  bool measured);
>>   #else
>>   static inline int security_enclave_map(unsigned long prot)
>>   {
>>   	return 0;
>>   }
>> +static inline int security_enclave_load(struct vm_area_struct *vma,
>> +					unsigned long prot, bool measured)
>> +{
>> +	return 0;
>> +}
>>   #endif /* CONFIG_SECURITY */
>>   #endif /* CONFIG_INTEL_SGX */
> 
> Parameters to security_enclave_load() are specific on what's being loading only, but unspecific on which enclave to be loaded into. That kills the possibility of an LSM module making enclave dependent decisions.
> 
> Btw, if enclave (in the form of struct file) is also passed in as a parameter, it'd let LSM know that file is an enclave, hence would be able to make the same decision in security_mmap_file() as in security_enclave_map(). In other words, you wouldn't need security_enclave_map().

Sorry, you want security_enclave_load() to stash a reference to the 
enclave file in some security module-internal state, then match it upon 
later security_mmap_file() calls to determine that it is dealing with an 
enclave, and then adjust its logic accordingly?  When do we release that 
reference?


