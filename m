Return-Path: <SRS0=YIp+=U3=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95022C4321A
	for <linux-sgx@archiver.kernel.org>; Fri, 28 Jun 2019 16:16:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5D28D20645
	for <linux-sgx@archiver.kernel.org>; Fri, 28 Jun 2019 16:16:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=tycho.nsa.gov header.i=@tycho.nsa.gov header.b="EoiRUClF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726686AbfF1QQo (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 28 Jun 2019 12:16:44 -0400
Received: from upbd19pa09.eemsg.mail.mil ([214.24.27.84]:45160 "EHLO
        UPBD19PA09.eemsg.mail.mil" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726605AbfF1QQn (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Fri, 28 Jun 2019 12:16:43 -0400
X-EEMSG-check-017: 206635601|UPBD19PA09_EEMSG_MP9.csd.disa.mil
Received: from emsm-gh1-uea11.ncsc.mil ([214.29.60.3])
  by UPBD19PA09.eemsg.mail.mil with ESMTP/TLS/DHE-RSA-AES256-SHA256; 28 Jun 2019 16:16:34 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=tycho.nsa.gov; i=@tycho.nsa.gov; q=dns/txt;
  s=tycho.nsa.gov; t=1561738595; x=1593274595;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=KiYsOj62SkyoxayPud4JFXbxXEuNb7E4QQTsRLRYAY4=;
  b=EoiRUClFgtM0iLgAnu04ryP/MAdMXtAFrVe0cCq0gELVxkoMB30qDEg0
   yQLHlAK7lQ4N0hCUNjoOX6Lkt9reesQEOOcbbRDxSfwP0WQ6DeTwHrDV0
   CeAHzgxJR7aoCKdITqEhGqtni6aFPHAwLKp99AnP6Nb0ToCloMRIWRkFc
   46PDB/7282oXCPFDLyq1ea0QguJYyB7CyOmAKEK8G+HkXH03lsncfk81z
   3qd4looL6MR5zC9Gt32d638kekH7R7ZnhmG54J+jhBxATAOlbhHDWcO8t
   1nYLKv/Zut0Ub675pGGOwuz36M7k9ii/zP2ie6YP4lvhIb2mKUCRfXNXC
   g==;
X-IronPort-AV: E=Sophos;i="5.63,428,1557187200"; 
   d="scan'208";a="29562359"
IronPort-PHdr: =?us-ascii?q?9a23=3Akic5UBSseAKYy6hcTJQ1h/cUS9psv+yvbD5Q0Y?=
 =?us-ascii?q?Iujvd0So/mwa67YxWOt8tkgFKBZ4jH8fUM07OQ7/m6HzZYqsfQ+DBaKdoQDk?=
 =?us-ascii?q?ZD0Z1X1yUbQ+e9QXXhK/DrayFoVO9jb3RCu0+BDE5OBczlbEfTqHDhpRQbGx?=
 =?us-ascii?q?H4KBYnbr+tQt2agMu4zf299IPOaAtUmjW9falyLBKrpgnNq8Uam4RvJrsvxh?=
 =?us-ascii?q?fTvHdEZ+tayGdsKFmOmxrw+tq88IRs/ihNpv4t7dJMXbn/c68lUbFWETMqPn?=
 =?us-ascii?q?wv6sb2rxfDVwyP5nUdUmUSjBVFBhXO4Q/5UJnsrCb0r/Jx1yaGM8L4S7A0Qi?=
 =?us-ascii?q?mi4LxwSBD0kicHNiU2/3/Rh8dtka9UuhOhpxh4w47JfIGYMed1c63Bcd8GQ2?=
 =?us-ascii?q?dKQ91cXDJdDIyic4QPDvIBPedGoIn7u1sOtga1CQ21CO/y1jNEmnr60Ks03O?=
 =?us-ascii?q?Q7FQHNwRIuEdQAvn/JqNn5LakfXOSwwKTO0D7Nbe5Z2S3l5YbVbB4hr/GCU7?=
 =?us-ascii?q?F+f8XfxkYgFR/KgFqLpIz5PT6YzPgBv3SV4udiU++klm4pqxt2ojiq3soil5?=
 =?us-ascii?q?XJiZwNylDE6yp5xps+K8C9SEFhZd6kFIVftiGHPIZxWcMtXnpotT0myrwGpZ?=
 =?us-ascii?q?G7fC8KxI4hxx7EcfOLaYeI4hX9VOuIJzpzmXFreKqnihqv/kWtxffwW8mp3F?=
 =?us-ascii?q?pQsCZIncfAumoQ2xHV98OJUOFy/l271jaKzw3T7+ZELl0qmqfDMJ4hx6Iwlo?=
 =?us-ascii?q?IUsUTeAi/6gEX2g7GSdkUj4uWo9/7oYq/npp+BLI94kB3+M6Qylcy/BuQ0KA?=
 =?us-ascii?q?4OUHSA+eugzrHj+Ez5QLFSgv03lKnWrozaKNwGqqO2DAJZyIYu5wulAzu439?=
 =?us-ascii?q?kUg2MLIE9ddBKClYfpOlXOIP7iDfe4hlShiCxryO3dPrD6HpXMLmTMkLfmfb?=
 =?us-ascii?q?pn7U5c0xA8wcpQ55JTFLENOOjzVVPptNzEEh85NBS5zPr5B9pgzIMeWH6ADr?=
 =?us-ascii?q?WWMaPTt1+I6fkiI+iKZI8Jpjn9L+Ip6OLpjX88gVUdZ7Wm3YMLaHCkGfRrO1?=
 =?us-ascii?q?6ZbmT2jdcHC2sKvBAyQ/DqiF2YUD5TfGqyX6Uk5jE7Fo2mF5zDRoergLGa3S?=
 =?us-ascii?q?e7GIFWaX5CClyWDXjocICEUe8WaC2OOs9hjiAEVb+5Ro8jzx6urgz6y7lgLu?=
 =?us-ascii?q?bO4S0Xr5Hj1Nt05+3Vix4y8yd5D8Cc02GLUmF1kXkERz4w3KBjv0N9zk2P3r?=
 =?us-ascii?q?R/g/xdDdZT/e9GUh8mNZ7AyOx3E9TyWgPHfteUR1eqW86mAT4+T98q3d8ObF?=
 =?us-ascii?q?hyG8+4ghDAwSWqGbkVmKKPBJAu9aLcxXfxLd5ny3nazKkhk0UmQsxXOG2ih6?=
 =?us-ascii?q?5/8RXTBoHQn0WCiamlabkc3DTM9GefzWuCpURYUAltXqXYWXAQeFDbrcr25k?=
 =?us-ascii?q?zcVb+iE7cnPRVbyc6ENKRKbsfljVJcRPfsIN7eeX6+m3+sBRaUwbOBdJHqdH?=
 =?us-ascii?q?sZ3CXcDkgEjg8S8G2YNQgxGCihuXjSDD9wGlL1ZUPj7+1+pGm8Tk8uwAGAd1?=
 =?us-ascii?q?dh2Kat+h4JmfycTOse37wFuCclrzV0HUyy39fMB9WcvQZhZqJcbsgj71ddyW?=
 =?us-ascii?q?LZrBdwPp2mL6B+mFEedx57sF/p1xVyEo9Ai9QlrGs2zApuLqKVyE9OeCmD3Z?=
 =?us-ascii?q?/uOrzbMHLy8wyva6HMx1He3tKW9bkV6PkjqlXjuh2pGVQm83l9z9ZV1H6c7I?=
 =?us-ascii?q?3QDAUOSZLxTlo39x9iqrHYZyk94JnU1WdtMamvqTLC3cgmBO47xRahZdtfN7?=
 =?us-ascii?q?mEFADqGc0AG8euMPAqm0Subh8cIe9d7rA0MN28e/uGwqGrOv1gkyygjWlc4Y?=
 =?us-ascii?q?B91F6M+DR4SuLSw5kFxPSY1BOdVzjglFehrtz3mYdcaDEWA2q/1S/kCZVSZq?=
 =?us-ascii?q?JsZ4YLD3mhI8mtytV5nZ7tVGZS9ES/CFMexM+pZR2SYkT/3QJOyUQXoWanmS?=
 =?us-ascii?q?yjwjx6lDEptLaf0zbIw+TjexsLIHJERG5njV30O4i7k8gaXFS0bwgujBal6l?=
 =?us-ascii?q?z6yLZUpKlkMWbTR0VIcDbyL2FmU6u/qqCObNJI6JMt4m1rV7H2UVGcRfq1iB?=
 =?us-ascii?q?YWySLoVSMKzz03bTCh/IX4mRNSiWSBIXI1p33cL4U4jzzf/t3HWflJ3jccXy?=
 =?us-ascii?q?5+zXHsC1G6d/vjtYGPmp7F9OL4XGK7V4ZPdjHrwJmbsy2T5Gt2DBn5lPe2zJ?=
 =?us-ascii?q?mvMwEg0iz8n+JjVibJqhv6Kt3p3r65MuUhZUBrB1765sxSHoB4j5t2hZcM1H?=
 =?us-ascii?q?xcjZKQqykpi2D2ZO5H1Lr+YXxFfjsCx9rY8UCxw0F4Bm6YzIL+EHOGy41uYM?=
 =?us-ascii?q?fsMTBe4T40880fUPTc17dDhyYg5wPj/A8=3D?=
X-IPAS-Result: =?us-ascii?q?A2ChAgA8PBZd/wHyM5BlHAEBAQQBAQcEAQGBZ4FtKoE7A?=
 =?us-ascii?q?TIohByTQQEBAQEBAQaBCS2JWZEUCQEBAQEBAQEBATQBAgEBhEACgwAjOBMBA?=
 =?us-ascii?q?wEBAQQBAQEBBAEBbIpDgjopAYJmAQEBAQMjFUEQCxUBAgICIwMCAkYRBgEMB?=
 =?us-ascii?q?gIBAYJTDD+BdxSnRYEyhUeDNYFGgQwoi18XeIEHgREngms+h06CWASOLYYol?=
 =?us-ascii?q?VcJghiCH5FUBhuXYy2NAJkwIYFYKwgCGAghD4MnkSEjAzCBBgEBjz8BAQ?=
Received: from tarius.tycho.ncsc.mil ([144.51.242.1])
  by emsm-gh1-uea11.NCSC.MIL with ESMTP; 28 Jun 2019 16:16:33 +0000
Received: from moss-pluto.infosec.tycho.ncsc.mil (moss-pluto [192.168.25.131])
        by tarius.tycho.ncsc.mil (8.14.4/8.14.4) with ESMTP id x5SGGUaR019221;
        Fri, 28 Jun 2019 12:16:31 -0400
Subject: Re: [RFC PATCH v4 10/12] security/selinux: Add enclave_load()
 implementation
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
 <20190619222401.14942-11-sean.j.christopherson@intel.com>
 <960B34DE67B9E140824F1DCDEC400C0F6551877E@ORSMSX116.amr.corp.intel.com>
 <b36d6fd0-3135-e48d-ed84-d69853bd79f1@tycho.nsa.gov>
 <960B34DE67B9E140824F1DCDEC400C0F6551B824@ORSMSX116.amr.corp.intel.com>
From:   Stephen Smalley <sds@tycho.nsa.gov>
Message-ID: <99499d1a-56eb-60b0-596c-6d24e38d4757@tycho.nsa.gov>
Date:   Fri, 28 Jun 2019 12:16:30 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <960B34DE67B9E140824F1DCDEC400C0F6551B824@ORSMSX116.amr.corp.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On 6/27/19 4:19 PM, Xing, Cedric wrote:
>> From: linux-sgx-owner@vger.kernel.org [mailto:linux-sgx-
>> owner@vger.kernel.org] On Behalf Of Stephen Smalley
>> Sent: Tuesday, June 25, 2019 2:10 PM
>>
>> On 6/21/19 5:22 PM, Xing, Cedric wrote:
>>>> From: Christopherson, Sean J
>>>> Sent: Wednesday, June 19, 2019 3:24 PM
>>>>
>>>> Intended use of each permission:
>>>>
>>>>     - SGX_EXECDIRTY: dynamically load code within the enclave itself
>>>>     - SGX_EXECUNMR: load unmeasured code into the enclave, e.g.
>>>> Graphene
>>>
>>> Why does it matter whether a code page is measured or not?
>>
>> It won't be incorporated into an attestation?
> 
> Yes, it will. And because of that, I don't think LSM should care.
> 
>>
>>>
>>>>     - SGX_EXECANON: load code from anonymous memory (likely Graphene)
>>>
>>> Graphene doesn't load code from anonymous memory. It loads code
>> dynamically though, as in SGX_EXECDIRTY case.
>>
>> So do we expect EXECANON to never be triggered at all?
> 
> I don't think so. And from security perspective, the decision I think shall base on whether the source pages are (allowed to be made) executable.
> 
>>
>>>
>>>>     - SGX_EXECUTE: load an enclave from a file, i.e. normal behavior
>>>
>>> Why is SGX_EXECUTE needed from security perspective? Or why isn't
>> FILE__EXECUTE sufficient?
>>
>> Splitting the SGX permissions from the regular ones allows distinctions
>> to be made between what can be executed in the host process and what can
>> be executed in the enclave.  The host process may be allowed
>> FILE__EXECUTE to numerous files that do not contain any code ever
>> intended to be executed within the enclave.
> 
> Given an enclave and its host process, any executable contents could be allowed in
> 1) Neither the enclave nor the host
> 2) Enclave only
> 3) Host only
> 4) Both the enclave and the host
> 
> Given the fact that enclave can access host's memory, if a piece of code is NOT allowed in the host, then it shouldn't be allowed in enclave either. So #2 shall never happen.
> 
> An enclave dictates/enforces its own contents cryptographically, so it's unnecessary to enforce #3 by LSM IMO.
> 
> Then #1 and #4 are the only 2 cases to be supported - a single FILE__EXECUTE is sufficient.
> 
> I'm not objecting to new permissions to make things more explicit, but that'd require updates to user mode tools. I think it just easier to reuse existing permissions.

FWIW, adding new permissions only requires updating policy 
configuration, not userspace code/tools.  But in any event, we can reuse 
the execute-related permissions if it makes sense but still consider 
introducing additional, new permissions, possibly in a separate 
"enclave" security class, if we want explicit control over enclave 
loading, e.g. ENCLAVE__LOAD, ENCLAVE__INIT, etc.

One residual concern I have with the reuse of FILE__EXECUTE is using it 
for the sigstruct file as the fallback case.  If the sigstruct is always 
part of the same file as the code, then it probably doesn't matter.  But 
otherwise, it is somewhat odd to have to allow the host process to 
execute from the sigstruct file if it is only data (the signature).


