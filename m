Return-Path: <SRS0=BFWe=UY=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4779FC48BD5
	for <linux-sgx@archiver.kernel.org>; Tue, 25 Jun 2019 20:48:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1740E205ED
	for <linux-sgx@archiver.kernel.org>; Tue, 25 Jun 2019 20:48:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=tycho.nsa.gov header.i=@tycho.nsa.gov header.b="dDm1QEFM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726422AbfFYUsd (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 25 Jun 2019 16:48:33 -0400
Received: from upbd19pa10.eemsg.mail.mil ([214.24.27.85]:46061 "EHLO
        upbd19pa10.eemsg.mail.mil" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726053AbfFYUsd (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Tue, 25 Jun 2019 16:48:33 -0400
X-EEMSG-check-017: 235564070|UPBD19PA10_EEMSG_MP10.csd.disa.mil
Received: from emsm-gh1-uea11.ncsc.mil ([214.29.60.3])
  by upbd19pa10.eemsg.mail.mil with ESMTP/TLS/DHE-RSA-AES256-SHA256; 25 Jun 2019 20:48:29 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=tycho.nsa.gov; i=@tycho.nsa.gov; q=dns/txt;
  s=tycho.nsa.gov; t=1561495709; x=1593031709;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=MSfZVikYJFvpHGCJvjCguWrYquay7d8+I+tuynlxbwk=;
  b=dDm1QEFMfMs8whkW+H6m1abKfIA9nWsmNM9eR/9MLH6OTuhU7znwoLHS
   Bh2Xf0eDAi2vZyY4Dm+Po6VRS5IPtBpHRtLjDfz0NHJRWkZ17zLHJw2V4
   iqEak9mlc9mOo7ZJBg8buUAFLDFe5WZaFlC47h6tyvd6tXA289lzCe9wI
   R7htypujl1UFENN2gLpUzHNowOyS/2R4w75xM7O6tCi5Q2NFET856+PVM
   1HJCWrU0xBVi34V76K1NIHh/nZlCjnM1jf0RhPYXX6c7uGb4H/fPCR6jp
   wHthjo1KdGjqTTOuk1wD2EEwUPI9/jvxjvKY/Bns8+X2BVImtUktl0rhz
   w==;
X-IronPort-AV: E=Sophos;i="5.63,417,1557187200"; 
   d="scan'208";a="29420040"
IronPort-PHdr: =?us-ascii?q?9a23=3AT61FfxGP/4Rq6aLicx84Xp1GYnF86YWxBRYc79?=
 =?us-ascii?q?8ds5kLTJ76oM64bnLW6fgltlLVR4KTs6sC17OM9fm8EjVasd7B6ClELMUVEU?=
 =?us-ascii?q?ddyI0/pE8JOIa9E0r1LfrnPWQRPf9pcxtbxUy9KlVfA83kZlff8TWY5D8WHQ?=
 =?us-ascii?q?jjZ0IufrymUoHdgN6q2O+s5pbdfxtHhCanYbN1MR66sRjdutMZjId/NKo90A?=
 =?us-ascii?q?bFr3RHd+hL229lJk+YkxLg6sut5pJu/Dlct+87+8JcTan2erkzQKBFAjghL2?=
 =?us-ascii?q?07/tDguwPZTQuI6HscU2EWnQRNDgPY8hz0XYr/vzXjuOZl1yaUIcP5TbYvWT?=
 =?us-ascii?q?S/9KhrUwPniD0GNzEi7m7ajNF7gb9BrxKgoxx/xJPUYJ2QOfFjcK7RYc8WSG?=
 =?us-ascii?q?xcVctKSSdPHp2zYJcOD+oZPOZXsY/9p0cVrRCjAQWgHf7jxiNUinPz26A13f?=
 =?us-ascii?q?4hEQXb1wI+GdwAvmnfoNHsOKoSVe25ya/FxijBYfxLwzfw8JXGfA4vof+MXr?=
 =?us-ascii?q?x+f8TexkYtGAzZgVudspDlMjGP2+gRr2SW4ehtWOSygGAnsQFxpT2vy98xhI?=
 =?us-ascii?q?nVmI0V0lDE+jt/wI0oONO4TVR0YdqgEJROtyCRKox7Qtg/TGFzoys61r0Hto?=
 =?us-ascii?q?K7fCgN0pgnwQXfZOadf4iH5RLjSv+cLDFlj3xmYLKynwu+/Eevx+HmVsS4zU?=
 =?us-ascii?q?xGojRKn9XSrHwByhre4dWdRPRn5EeuwzOP2hjW6uFDPE87i7LWK4Ukwr4sjp?=
 =?us-ascii?q?oTtlnDHjPulEX2kqCWckIk9/C06+v9eLXmp4KcN5RuhgHiMqUhhsy/AeMiPg?=
 =?us-ascii?q?gIQ2eb4viz2Kfm/U34RLVGlvw2kq/Hv5DGPckXu6G0DgBP3osj9hqzFSmq3d?=
 =?us-ascii?q?sGkXUdMV5JYBeHgJLoO1HKLvD4F/C/g1G0nTdw2v/GJabsAonNL3ffkLfheq?=
 =?us-ascii?q?xx60hHyAUp19xf6JVUCq8ZLPLpRkDxrMDYDgM+MwGs3+noFshy1pkfWW2TGK?=
 =?us-ascii?q?OYP6LSsVmH5u80IumMYpMVtyj5K/Q/+/Huino5k0cHfaa1xZsXdGy4HvN+Lk?=
 =?us-ascii?q?WCf3XjmNEBHX0IvgYkUOPqiEeCUT9IZ3auWKI8/jE7B5y8DYfYQYCthqeM3C?=
 =?us-ascii?q?a9Hp1KeG9GDkqAHmvvd4WBQ/0Mcj6dItd9kjwYUrisU40h2gu0tA/5yLpnKf?=
 =?us-ascii?q?DY+jYCupLg19h15uvTmg809TFvC8Sd0meNT3x7n28SRj822rx/rlJ5yluZza?=
 =?us-ascii?q?d4hPlYH8RJ5/xVSgc6KYLcz+tiBtD2WwLBeMqJSVm/TtW9DjEwQck8w8EBY0?=
 =?us-ascii?q?ljAdWulBPD0DSwA78TibOLAIY48qXG33j+P8x90WrJ1LE9j1k6RctCLWmmhq?=
 =?us-ascii?q?959wjOCI/Fil6ZmLi2eqQBxi7N9XuDzGqXsEFdVw5/TLjFXXQBaUbNs9T56V?=
 =?us-ascii?q?3NT6W0BbQkLARB08iCJbVOatHzilVGXvjjMszEY22tg2ewGQqIxrSUYYrxZW?=
 =?us-ascii?q?od2CTdCE4ZkwEc5nuGKwc+CTm7o27EDzxhC0jvY0Xy/ul6sn+7SVU0zw6SZU?=
 =?us-ascii?q?17y7W14gIVheCbS/4L0LMEuSMhqzF1HFmn2tLaEcaPqxB7fKVbetwy/k1H1X?=
 =?us-ascii?q?7CtwFmP5ygKbxiiUAacwhto0zu0BB3AJ1akcc2tHMq0BZyKaWA3VxdbTyYxo?=
 =?us-ascii?q?7/O73NJmnp4B+va7TZ2kzQ0NaS5KgP8u81q1TlvAG1CEUi929r3MVS03uZ/p?=
 =?us-ascii?q?/KFhYdUYrtUkYr8Bh3v7PaYiw654POz31sMLK0vyTE290zAesq1Begc81YMK?=
 =?us-ascii?q?OeGw/4C9caCNS2KOw2h1ipaQoJM/1I+64qIcyqbfuG17StPOZ7gj2mi39K4I?=
 =?us-ascii?q?F70kKQ6SV8TvTE0IoCw/GdxgGHTSvzjE+9ssDrnoBJfTUSHnejySjjH4NRZb?=
 =?us-ascii?q?N9fZwNCWiwJ8273NJ+h4TiW3RA7l6sG0sG2NO1eRqVd1H93xNf1VgXoXy9ni?=
 =?us-ascii?q?u11DJ0kzYzrqqDxiPOxeXidRUdNmFXQ2liiE/mIZKogNACQEiocw8pmQOq5U?=
 =?us-ascii?q?bg2adbq79yIHfVQUdKYSf2K2ViUqqsubaYf8FP75Yo4m1rV7H2UVGcRfq1iB?=
 =?us-ascii?q?YWySLoVSMKzz03bTCh/IX4mRNSiWSBIXI1p33cL4U4jzzf/t3HWflJ3jccXy?=
 =?us-ascii?q?5+zXHsC1G6d/vjtYGPmp7F9OL4XGK7V4ZPdjHrwJmbsy2T5Gt2DBn5lPe2zJ?=
 =?us-ascii?q?mvMwEg0iz8n+JjVibJqhv6Kt3p3r65MuUhZUBrB1765sxSHoB4j5t2hZcM1H?=
 =?us-ascii?q?xcjZKQqykpi2D2ZO5H1Lr+YXxFfjsCx9rY8UCxw0F4Bm6YzIL+EHOGy41uYM?=
 =?us-ascii?q?fsMTBe4T40880fUPTc17dDhyYg5wPl/A8=3D?=
X-IPAS-Result: =?us-ascii?q?A2BOAAAgiBJd/wHyM5BlGgEBAQEBAgEBAQEHAgEBAQGBZ?=
 =?us-ascii?q?4FtKoE8MoQ9knlNAQEBAQEBBoERJYlTkQ4JAQEBAQEBAQEBNAECAQGEQAKCd?=
 =?us-ascii?q?SM4EwEDAQEBBAEBAQEEAQFsikOCOikBgmYBAQEBAyMEEUEQCxUBAgICJgICV?=
 =?us-ascii?q?wYBDAgBAYJfP4F3FKVWfjOFR4MpgUaBDCiLXhd4gQeBOAyCXz6HToJYBI4hh?=
 =?us-ascii?q?iaVTQmCF4IekUcGG5dOLYx7mR0hgVgrCAIYCCEPgyiCTBcUjigjA4E2AQGPX?=
 =?us-ascii?q?AEB?=
Received: from tarius.tycho.ncsc.mil ([144.51.242.1])
  by emsm-gh1-uea11.NCSC.MIL with ESMTP; 25 Jun 2019 20:48:28 +0000
Received: from moss-pluto.infosec.tycho.ncsc.mil (moss-pluto [192.168.25.131])
        by tarius.tycho.ncsc.mil (8.14.4/8.14.4) with ESMTP id x5PKmR80021153;
        Tue, 25 Jun 2019 16:48:27 -0400
Subject: Re: [RFC PATCH v4 07/12] LSM: x86/sgx: Introduce ->enclave_map() hook
 for Intel SGX
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
 <20190619222401.14942-8-sean.j.christopherson@intel.com>
 <960B34DE67B9E140824F1DCDEC400C0F6551847B@ORSMSX116.amr.corp.intel.com>
From:   Stephen Smalley <sds@tycho.nsa.gov>
Message-ID: <8235709b-9034-4751-30ce-720e41e31525@tycho.nsa.gov>
Date:   Tue, 25 Jun 2019 16:48:27 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <960B34DE67B9E140824F1DCDEC400C0F6551847B@ORSMSX116.amr.corp.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On 6/21/19 12:54 PM, Xing, Cedric wrote:
>> From: Christopherson, Sean J
>> Sent: Wednesday, June 19, 2019 3:24 PM
>>
>> diff --git a/security/security.c b/security/security.c
>> index 613a5c00e602..03951e08bdfc 100644
>> --- a/security/security.c
>> +++ b/security/security.c
>> @@ -2359,3 +2359,10 @@ void security_bpf_prog_free(struct bpf_prog_aux *aux)
>>   	call_void_hook(bpf_prog_free_security, aux);
>>   }
>>   #endif /* CONFIG_BPF_SYSCALL */
>> +
>> +#ifdef CONFIG_INTEL_SGX
>> +int security_enclave_map(unsigned long prot)
>> +{
>> +	return call_int_hook(enclave_map, 0, prot);
>> +}
>> +#endif /* CONFIG_INTEL_SGX */
> 
> Why is this new security_enclave_map() necessary while security_mmap_file() will also be invoked?

security_mmap_file() doesn't know about enclaves.  It will just end up 
checking FILE__READ, FILE__WRITE, and FILE__EXECUTE to /dev/sgx/enclave. 
This was noted in the patch description.



