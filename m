Return-Path: <SRS0=BFWe=UY=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87920C48BD6
	for <linux-sgx@archiver.kernel.org>; Tue, 25 Jun 2019 21:05:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5111220663
	for <linux-sgx@archiver.kernel.org>; Tue, 25 Jun 2019 21:05:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=tycho.nsa.gov header.i=@tycho.nsa.gov header.b="b3C/3DQy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726040AbfFYVFm (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 25 Jun 2019 17:05:42 -0400
Received: from usfb19pa13.eemsg.mail.mil ([214.24.26.84]:52931 "EHLO
        USFB19PA13.eemsg.mail.mil" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726304AbfFYVFl (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Tue, 25 Jun 2019 17:05:41 -0400
X-EEMSG-check-017: 277715108|USFB19PA13_EEMSG_MP9.csd.disa.mil
Received: from emsm-gh1-uea11.ncsc.mil ([214.29.60.3])
  by USFB19PA13.eemsg.mail.mil with ESMTP/TLS/DHE-RSA-AES256-SHA256; 25 Jun 2019 21:05:39 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=tycho.nsa.gov; i=@tycho.nsa.gov; q=dns/txt;
  s=tycho.nsa.gov; t=1561496740; x=1593032740;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=sBZgGmHJuiBnk792AFQ67+EPOTVp4Qd5F0AZcK7fGEs=;
  b=b3C/3DQyZE3X3CUrybJn6WTvN0//ZX9vPqd9GPH+80ZisQnMG3DQ5TD+
   WClWkknZJnLvNuvcbzEY5k0TTBt3u0NQgEYJEfok5EC1aJharWr6xetoY
   3W2AlUkpyfxfmFGaqgVSaIG4Vi7TB4BJU8mIQmFEqJtIwB0ehryVAmJd4
   wNvb57VOPOMHR0d2p7d15VCyxYgkEq1L55FkuX+r2zOXNLKwZ+hMMG13e
   9CDu29FMprLGa2KJ1g8c+ibtZ/6FtzsP5XnjXcEl87rtVEITcJbdVtmhK
   vUGCI12J37uBXVLzZtRzWraEAQeAMxqWxcHazAJYd05GCh4PkjAgCozXv
   Q==;
X-IronPort-AV: E=Sophos;i="5.63,417,1557187200"; 
   d="scan'208";a="29420602"
IronPort-PHdr: =?us-ascii?q?9a23=3A/vIETxBTrASe1aDNi3qYUyQJP3N1i/DPJgcQr6?=
 =?us-ascii?q?AfoPdwSP38pc6wAkXT6L1XgUPTWs2DsrQY0rCQ6vyrADZQqdbZ6TZeKcUKD0?=
 =?us-ascii?q?dEwewt3CUYSPafDkP6KPO4JwcbJ+9lEGFfwnegLEJOE9z/bVCB6le77DoVBw?=
 =?us-ascii?q?mtfVEtfre9FYHdldm42P6v8JPPfQpImCC9YbRvJxmqsAndrMYbjZZ8Jqor1x?=
 =?us-ascii?q?fErXREd/lIyW5rOFmfmwrw6tqq8JNs7ihcpugt+9JcXan/Yq81UaFWADM6Pm?=
 =?us-ascii?q?4v+cblrwPDTQyB5nsdVmUZjB9FCBXb4R/5Q5n8rDL0uvJy1yeGM8L2S6s0WS?=
 =?us-ascii?q?m54KdwVBDokiYHOCUn/2zRl8d9kbhUoBOlpxx43o7UfISYP+dwc6/BYd8XQ3?=
 =?us-ascii?q?dKU91PXCJdHIyzc4oPD/IAPelGqYn9u0AOpga6CQW1Ge/j1iNEinrw0KI0ye?=
 =?us-ascii?q?QhFRzN0hImEdwArX/YqMz5OacWXOywyqTD0DfNYO5M2Trl9YbGbB4hr/GPU7?=
 =?us-ascii?q?x+f8XexksgGB/KgFiLtYzoPSmY2vgRv2WV7edtU/+khW49qwF2pzii3toiip?=
 =?us-ascii?q?XXiYINylDL6yN5y5soK929UkF7ZdqkH4VQtiqHMIZ2Wd4tQ3pztSYmyrwJpZ?=
 =?us-ascii?q?67fC8QxJQh3B7QceaLc4eP4hL9TeucJypzinF9eL+nmhq//ketxvf8W8Wpyl?=
 =?us-ascii?q?pGsCVInsfWunwQ0RHY99KJReFn/ki73DaCzwXT6uZZLk8qjafbMJshwqIolp?=
 =?us-ascii?q?oUrETDAjf6mEXog6+ScUUp4vSo5P79YrXnu5+cLJV4ih3+M6symsy/Bv40Mg?=
 =?us-ascii?q?4SUGiA5euwzrjj/Uz9QLlSj/02lLfWsIzCKMgGqaO0DBVZ34Y+5xqlETur38?=
 =?us-ascii?q?oUkWMaIF5dfRKIlYnpO1XAIPDiCve/hkyhkCx2yPDdJbDhHpXMIWTDkLfmZ7?=
 =?us-ascii?q?p97VVcxxApwdBQ4JJUFKkNIOjvVU/pqNzYEhg5PhSozOn5Fdp9zIIeVn6VDq?=
 =?us-ascii?q?6WMaPSt1CI6/kuI+mKeI8apjL9J+I56P7piH8zgUUdcrWx3ZsLdHC4GexrI1?=
 =?us-ascii?q?6HbnX2hNcNC2UKshAiQ+zqkl2CUCVTZ2q1X6Ik5jE0FpimDZzERoCrm7GB3S?=
 =?us-ascii?q?G7HoFIaWBCEFyDDXDod4CcUfcWdC2SOtNhkiADVbW5SY8uzwuutAz5y7pgNO?=
 =?us-ascii?q?bU4TcXtZHg1Nh04e3cixcy+CdwD8Sc1WGNUm51knkJRz8wwKBwv0h9xk2f3q?=
 =?us-ascii?q?h/hvxSDcZT6O9RUgcmKZ7cyPR3C9TzWgLHY9eIR0+qQs6pATA+Vd8x3dAObF?=
 =?us-ascii?q?hnG9m4jRDMwTCqA7kLmLyPHpA09bjc33fpLcZn13nGzLUhj0UhQsZXMW2mh6?=
 =?us-ascii?q?h/9xXcBoLQiEWWibqldbkG3C7M6GeCzXOCvERfUAFtTKXFWW4Qa1DIrdT2+E?=
 =?us-ascii?q?zCVaWiCbc5PQtbz86NNK9KZsfujVVcS/fpIM7ebH6pm2esGRaIwauBbJH0dG?=
 =?us-ascii?q?UZ3SXdDlUEkg8I8HaYOggxGD2hr3jdDDNwD1LvZV3j8e1kpHO8VE80wBmAb1?=
 =?us-ascii?q?d92Lqt5h4VmfucRusd37IFvCchrzR0E0y4397MF9WMvRBhfKJHbtwj+ldHyX?=
 =?us-ascii?q?nZuhd8PpymM6BtmFoefx5rsEPp0hV9Ep9AntQyrHM20ApyLrqV309beDODw5?=
 =?us-ascii?q?/xOqfbKnLu8xCvcaHWx1/e0NKI9acV8/k4qlPjvB23GUom6Xloz95V036E7J?=
 =?us-ascii?q?XQEAUSSY7xUlow9xVipbHaZy4955nO1X1tKqm5qTnC1MgsBOQ7yxasZdBfML?=
 =?us-ascii?q?mLFAXqCc0VG9CuKPA2m1iudh8LIfpd9LAqMM+8d/uJwqirPP1+kzKglmlH4Y?=
 =?us-ascii?q?Z90l6S+Cp4UOLHw5EFw/SA1AudSzj8lEuhstzwmY1cYTESA3a/yS//CY5SeK?=
 =?us-ascii?q?JyZ4ALBnmqI8GtwdV+nZHtUWZC9FG/H1MGxNOpeR2KYlz/wwJQyUQXoWagmS?=
 =?us-ascii?q?ajwTx0lCsprraF0yzIwuTjewALNXJMRGlnlV3sO5S7j8gGXEi0aAgkjBSl5V?=
 =?us-ascii?q?zkyKhUv6lwMW/TQUVWcCjyK2FiU7e/uqCebM5I7ZN7+RlQBa6MYFaVDvbWrh?=
 =?us-ascii?q?cA0iipVz9VyTwhdjrsqpT/kDR7jn6QKDB4q3+PPYk67hfF5cfAQuZR0yAdQy?=
 =?us-ascii?q?88wQLaD170HZPhqc6ZnpGFsKa1V3igTYFUaSnm15iHsgO643FnBVu0mPXl3p?=
 =?us-ascii?q?XFGBI50iiz7NBpViTOoRC0Novizae5NqR8d0prBVnx7eJ+G4djgs0xgo0d3T?=
 =?us-ascii?q?4RgZDDrlQdlmKmCslWwaLzajI2QDcPx9PEqFz+1FZLMmOCx4W/UG6UhMRmeY?=
 =?us-ascii?q?/pMSstxish4pUSW++v57tekH4w+wfpoA=3D=3D?=
X-IPAS-Result: =?us-ascii?q?A2BPAADaixJd/wHyM5BmGgEBAQEBAgEBAQEHAgEBAQGBZ?=
 =?us-ascii?q?4FtKoE8MoQ9knlNAQEBAQEBBoERJX6IVZEOCQEBAQEBAQEBATQBAgEBhEACg?=
 =?us-ascii?q?nUjOBMBAwEBAQQBAQEBBAEBbIpDgjopAYJmAQEBAQMjFUEQCxUBAgICJgICV?=
 =?us-ascii?q?wYBDAgBAYJfP4F3FKVTgTGFR4MqgUaBDCiLXhd4gQeBEScMgio1PodOglgEj?=
 =?us-ascii?q?iGGJpVNCYIXgh6RRwYbl04tjHuZHSGBWCsIAhgIIQ+DKIJMFxSOKCMDgTYBA?=
 =?us-ascii?q?Y9cAQE?=
Received: from tarius.tycho.ncsc.mil ([144.51.242.1])
  by emsm-gh1-uea11.NCSC.MIL with ESMTP; 25 Jun 2019 21:05:38 +0000
Received: from moss-pluto.infosec.tycho.ncsc.mil (moss-pluto [192.168.25.131])
        by tarius.tycho.ncsc.mil (8.14.4/8.14.4) with ESMTP id x5PL5ba9027639;
        Tue, 25 Jun 2019 17:05:37 -0400
Subject: Re: [RFC PATCH v4 08/12] security/selinux: Require SGX_MAPWX to map
 enclave page WX
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
 <20190619222401.14942-9-sean.j.christopherson@intel.com>
 <960B34DE67B9E140824F1DCDEC400C0F655184C3@ORSMSX116.amr.corp.intel.com>
From:   Stephen Smalley <sds@tycho.nsa.gov>
Message-ID: <6f86681a-5478-c46c-b74a-52a973b53320@tycho.nsa.gov>
Date:   Tue, 25 Jun 2019 17:05:37 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <960B34DE67B9E140824F1DCDEC400C0F655184C3@ORSMSX116.amr.corp.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On 6/21/19 1:09 PM, Xing, Cedric wrote:
>> From: Christopherson, Sean J
>> Sent: Wednesday, June 19, 2019 3:24 PM
>>
>> diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
>> index 3ec702cf46ca..fc239e541b62 100644
>> --- a/security/selinux/hooks.c
>> +++ b/security/selinux/hooks.c
>> @@ -6726,6 +6726,23 @@ static void selinux_bpf_prog_free(struct bpf_prog_aux *aux)
>>   }
>>   #endif
>>
>> +#ifdef CONFIG_INTEL_SGX
>> +static int selinux_enclave_map(unsigned long prot)
>> +{
>> +	const struct cred *cred = current_cred();
>> +	u32 sid = cred_sid(cred);
>> +
>> +	/* SGX is supported only in 64-bit kernels. */
>> +	WARN_ON_ONCE(!default_noexec);
>> +
>> +	if ((prot & PROT_EXEC) && (prot & PROT_WRITE))
>> +		return avc_has_perm(&selinux_state, sid, sid,
>> +				    SECCLASS_PROCESS2, PROCESS2__SGX_MAPWX,
>> +				    NULL);
> 
> Why isn't SGX_MAPWX enclave specific but process wide?

How would you tie it to a specific enclave?  What's the object/target 
SID?  The SID of the enclave inode?  Which one?  The source vma file, 
the /dev/sgx/enclave open instance, the sigstruct file, ...?  If a 
process can map one enclave WX, what's the benefit of preventing it from 
doing likewise for any other enclave it can load?



