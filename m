Return-Path: <SRS0=rpH8=UM=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98DA7C468B0
	for <linux-sgx@archiver.kernel.org>; Thu, 13 Jun 2019 17:02:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 715E020665
	for <linux-sgx@archiver.kernel.org>; Thu, 13 Jun 2019 17:02:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=tycho.nsa.gov header.i=@tycho.nsa.gov header.b="OK3uTvI9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726652AbfFMRCn (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 13 Jun 2019 13:02:43 -0400
Received: from ucol19pa11.eemsg.mail.mil ([214.24.24.84]:25123 "EHLO
        UCOL19PA11.eemsg.mail.mil" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729649AbfFMRCk (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Thu, 13 Jun 2019 13:02:40 -0400
X-EEMSG-check-017: 685646050|UCOL19PA11_EEMSG_MP9.csd.disa.mil
X-IronPort-AV: E=Sophos;i="5.63,369,1557187200"; 
   d="scan'208";a="685646050"
Received: from emsm-gh1-uea10.ncsc.mil ([214.29.60.2])
  by UCOL19PA11.eemsg.mail.mil with ESMTP/TLS/DHE-RSA-AES256-SHA256; 13 Jun 2019 17:02:28 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=tycho.nsa.gov; i=@tycho.nsa.gov; q=dns/txt;
  s=tycho.nsa.gov; t=1560445348; x=1591981348;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=fQPJBLSkf3ACIUxeaWnbhS8tEqmnVpDGMg9YbwW47Vk=;
  b=OK3uTvI9WKtHpetpMpEzs+xv0rL8UFFSG2LSI0p/winYWw6mB7sdG34s
   ChuE3rHnyKzgY+erPHoqsQsj9ozQD87bZqyUPAYbLeo+SO8ip7MFtKc81
   xpypRpP/hnu2w03QLA1k3Ak3D76x/EGZJr1uv7EdEdZ1tSlxJIpY+DP/w
   KxbnpK63Z+dKQBOZPTbE+0JUVzczk5sozdEnjr+svy5kklTrWUXurbnUw
   JoDu7+82GMKrDZo5khf20e5aSUl8VwKV/hR99o3Ki00jCqfphJAAMI2tL
   5d3DHLxzcGV8C1rgCooqr5sktlZxLSmofljatNss/riNZnIRuVBdDgPnb
   g==;
X-IronPort-AV: E=Sophos;i="5.63,369,1557187200"; 
   d="scan'208";a="24719124"
IronPort-PHdr: =?us-ascii?q?9a23=3ANIZgoheuzXyOjmxu8feBRPdqlGMj4u6mDksu8p?=
 =?us-ascii?q?Mizoh2WeGdxc68Zx2N2/xhgRfzUJnB7Loc0qyK6vmmADFRqs/Z7TgrS99lb1?=
 =?us-ascii?q?c9k8IYnggtUoauKHbQC7rUVRE8B9lIT1R//nu2YgB/Ecf6YEDO8DXptWZBUh?=
 =?us-ascii?q?rwOhBoKevrB4Xck9q41/yo+53Ufg5EmCexbal9IRmrsAndrNQajItmJ6o+1x?=
 =?us-ascii?q?fFvntFcPlKyG11Il6egwzy7dqq8p559CRQtfMh98peXqj/Yq81U79WAik4Pm?=
 =?us-ascii?q?4s/MHkugXNQgWJ5nsHT2UZiQFIDBTf7BH7RZj+rC33vfdg1SaAPM32Sbc0WS?=
 =?us-ascii?q?m+76puVRTlhjsLOyI//WrKkcF7kr5Vrwy9qBx+247UYZ+aNPxifqPGYNgWQX?=
 =?us-ascii?q?NNUttNWyBdB4+xaYUAD/AFPe1FsYfzoVUApga6CQW1Cu7izjpEi3nr1qM4zu?=
 =?us-ascii?q?shCxnL0hE+EdIAsHrar9v7O6kdXu+30KbGwi7Ob+9U1Drn9ITEbh4srPOKUL?=
 =?us-ascii?q?ltccTR004vFwbdg1uNtYzqISuV1uQTvGid8uFuSOevhHQjqwF1vDeuxtonh4?=
 =?us-ascii?q?7Sho0I0VDJ7jl5wYYpKt24T053e9ikEIBKuC2AOIt2Rd0iTnhutS0nxLMGvp?=
 =?us-ascii?q?u7czILyJQh3xPfaOKIc5KO4h39UOadOzB4hGhqeL+5mh288lCgx/XhWsS731?=
 =?us-ascii?q?tGtCpInsTWunwT2BHf9NKLRuZ780y8wziAzRrT5ftBIU0skKrbLIMuzaAom5?=
 =?us-ascii?q?oItETDAjf2mELrjK+Kbkkk+van6+DgYrj+up+TLZV0igDjMqQ1gMC/HeQ5PR?=
 =?us-ascii?q?QOX2ic4+i80qHs/VblT7lQi/02k63ZvIjbJcQduKG5HxdY3pss5huwFTur0M?=
 =?us-ascii?q?kUkWMZIF9KZh6LlZXlN0nLIP/iDPe/h1qskC1sx/DDJrDhGYjCLmPYnbf9fb?=
 =?us-ascii?q?dy905cyA0pwdBZ/JJbEKsNIP30Wk/vrNDYFAM2MxSow+b7D9VwzpgeVnyVDa?=
 =?us-ascii?q?+fKq/Ss0WE6f4vI+mWZY8Voyr9K/895/7uk3A5g0Qdfa6v3ZYMaXC4GOhmLF?=
 =?us-ascii?q?udYXb2ntgBFmIKtBIkTOP2kF2CTSJTZ3GqUq0g+D40FZimDYbfSYy3j72B3S?=
 =?us-ascii?q?G7HpJNa2BHDFCMDWnnd4GeV/gQbyKSJ9drkiYYWri5V48hyRauuRf+y7pmKO?=
 =?us-ascii?q?rU5yIZuYv41Ndr++LTiAsy9T1oD8Wdym2NSmZ0kX4VRz8ywq9yulJ9ylid3q?=
 =?us-ascii?q?himfBYFsJc5+lPUggkMZ7Q1et6C8r9WgjZZNeGVE6mQsm6ATE2Vt8x2MEBY0?=
 =?us-ascii?q?J8G9WkkxDC0DGnA6Eal7OVHpw46KHc0GbrJ8Z71XnG0LMtj148QstALWemnL?=
 =?us-ascii?q?Jw9xDPB47VlEWUj6KqdaUa3C7Q+2aP1GmOs19CUA52T6rFWWsSZlXZrdvn/E?=
 =?us-ascii?q?POVbyuBqo9MgtH18GCLrFGatrzjVVJXP3jIsjRY3qtm2esAhaF3reMbIvse2?=
 =?us-ascii?q?UA0yTREVMEkw8c/HudKwg+CTmuo3jEADxtC13veUXs/vd6qH+hSU801Q6KZV?=
 =?us-ascii?q?V717Wp4h4VmeCcS/QL07IGoighsTZ0HFW6397MENqPvQlhfKZdYdM7/lhH03?=
 =?us-ascii?q?nUtwh8PpymMqBjiUQScwVxv0PyyRp3Dp9MntQtrHMv1AByM76X0EtddzOE2p?=
 =?us-ascii?q?D9IrnXKnTu/BCocKPW2U/R0MyQ+qgR7PQ0sVLjvBumFkA66XVoz8FV02eA5p?=
 =?us-ascii?q?XNFAcSU5fxUkEt9xhgprHaeTIw54XO2n1pL6a0syXO29UzBOsq0hygZctQML?=
 =?us-ascii?q?uYFA/uFM0XH9OuJ/Iwm1imcB0JJ+BS+7QwP8Oid/qG3rSnM/pnnDKjlW5H+p?=
 =?us-ascii?q?xy0lqQ9ypgTe7Fx44FzOuF3guDTDr8lE2ust3zmYxdYDESGW2/yTL6C4JLeq?=
 =?us-ascii?q?JyeoMLA3+0I8Kr3tV+m4LtW3lA+VG9H1MJwtWpeRuJb1HmxQ1fz14XoX28mS?=
 =?us-ascii?q?ugyzx7iS0mobSF0CzJ2eTiewINOnRXS2l6kVfsPY+0gsgYXEe2cwgplAGl5U?=
 =?us-ascii?q?HhyqhVo6R/NXXTTl1Ofyj3IGBuSLe/tr2HY8RX8pMnrT1XUPigYVCdUrPyvg?=
 =?us-ascii?q?EV0z39EGdExDA0bTequo7nkBx8k2+dLXBzrGbHdsF03xvQ+NvcRftJ1DocWC?=
 =?us-ascii?q?Z4kSXXBkS7P9Sx4dWUmJPDs++lWmKlV51TdzTrzZ+atCu8421qABK+k+quld?=
 =?us-ascii?q?L5CQI6yzP018F2VSXUqxbxepXr16OgMeJ5ZEZoAELz69FhF4F6k4swgowQ2H?=
 =?us-ascii?q?cDipWb+noHjGHzPshB1qLibXoNQjgLz8TS4Aj/101pNmiJyJ7hVnWB3sthYM?=
 =?us-ascii?q?G3bXkV2iIl6sBHE6OU7L1CnStorVu0tAzRYf9gnjcb1PQh8mIag+AOuAor1C?=
 =?us-ascii?q?mdBaoSHUZANyz2ixuI98y+rLlQZGu3d7iw1E1+ncqkDL6YpAFRQ2z5dYk/Ei?=
 =?us-ascii?q?9w9Mp/LEjA32H06oHhYNPQd84ctgWIkxfciOhYMIoxlv8WiiV7I239uXkly/?=
 =?us-ascii?q?M+jRF1x5G1opWIK2V386KlGBJXKjr1Z8YL8DH3kalehtqW35yoHph5ATUEQo?=
 =?us-ascii?q?HoTf22Hz4Ir/vmNwGOECA6qnqAGLrfGxOf51lir37VD5+rMHSXLmEDzdp+XB?=
 =?us-ascii?q?mdOFBfgAcMUTUhnp42DACryNbicEhj+jAQ50f0qxpWxeJtNhn/SHzSpAauaj?=
 =?us-ascii?q?coVpefKABa4R1F50fQKcae9P58HzlE/p29qwyAMmybaB5JDWEVQEOEAErvPr?=
 =?us-ascii?q?mz5dba9eiYCfGzL/rIYbWSt+NeU+2Eyo6o0otj5zyMLNmAPmF+D/0n3UpORW?=
 =?us-ascii?q?p2G8LElDUVSiwWlzjBb9WbpBii5C14ssC//+rtWALs4ouCEL9SMdRp+xCrjq?=
 =?us-ascii?q?aPLe+QhCBlKTlG0pMA32PHyL8a3FQKkSFhayGtEagctS7KVK/QmbVYDx8BZy?=
 =?us-ascii?q?NoKstH9aI83g9WNM7ajNP1yqB3jvovB1hZUlzhn9mjZdYWLGGlKFPHGEGLOa?=
 =?us-ascii?q?ydKj3T2Mz4e6e8SbxOg+VStBC8oyuUHFH7NDSZizbpTwyvMf1LjCyDPhxev5?=
 =?us-ascii?q?q9chZ2BGjhS9LmcR27MMNtjT032b00gm3FNXIAMTRmdENNtLKQ5ztCgvpjA2?=
 =?us-ascii?q?xB8mZlLe6cliaa9ebYK4wasft2AitukeJa7283y7pT7CFYWvN1nDHeocJpo1?=
 =?us-ascii?q?GjiuOP0CZoUAJSqjZXg4KGpV9iOaTH+ZlGRXbE/gwC7X6LBhQFoNtlDdLvu6?=
 =?us-ascii?q?ROxdTViK3zLzJC+crO/cQAH8jUNN6HMH05PBvnGT7UCA8FTT+xOmHanUBSjO?=
 =?us-ascii?q?ue9meSrpchtJfsgoYOSqRAWVw0EPMaFlpqHNgYLJhrWTMklKaRjNQU6nqmsB?=
 =?us-ascii?q?nRWMJas4jfVvKSAPXvLDeZjaFeaxQT27/4MZ4TNozn1EN+cFZ3h4XKG0zMXd?=
 =?us-ascii?q?9Tpi1tdBM7oEJI8Cs2cmpm4E/sbEuG4GUSDuKzhh47kBB5Z6x57zrl5RE1YF?=
 =?us-ascii?q?HKviorjE4pmdj/mjeXWD/3MKq0G4pRDnynmVI2N8bAXwttbQC01XdhPTPASq?=
 =?us-ascii?q?MZ26Bsbkh3mQTcvt1JAvcaQqpaNkxDjcqLbuklhAwP4h6swlVKsK6cUspv?=
X-IPAS-Result: =?us-ascii?q?A2CoCAD5gAJd/wHyM5BlHAEBAQQBAQcEAQGBZYFiBSpqU?=
 =?us-ascii?q?QEyKIQWknZMAQIBAQEGgTWJUZELCQEBAQEBAQEBAS0HAQIBAYRAAoJJIzgTA?=
 =?us-ascii?q?QMBAQEEAQEBAQMBAWwcDII6KQGCZwEFIwQROAkQCxgCAiYCAlcGDQYCAQGCX?=
 =?us-ascii?q?z8BgXYUD6sBfjOEMgGBFIMjgUAGgQwoi10XeIEHgTiCaz6HToJYBItViEmVL?=
 =?us-ascii?q?gmCEoIbhCyMfwYbgiaVBo5GhW+RRiGBWCsIAhgIIQ+DJxOLAIVbIwMwAQEBA?=
 =?us-ascii?q?YECAQGQLQEB?=
Received: from tarius.tycho.ncsc.mil ([144.51.242.1])
  by EMSM-GH1-UEA10.NCSC.MIL with ESMTP; 13 Jun 2019 17:02:21 +0000
Received: from moss-pluto.infosec.tycho.ncsc.mil (moss-pluto [192.168.25.131])
        by tarius.tycho.ncsc.mil (8.14.4/8.14.4) with ESMTP id x5DH2HFM005493;
        Thu, 13 Jun 2019 13:02:17 -0400
Subject: Re: [RFC PATCH v1 2/3] LSM/x86/sgx: Implement SGX specific hooks in
 SELinux
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Cedric Xing <cedric.xing@intel.com>,
        linux-security-module@vger.kernel.org, selinux@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sgx@vger.kernel.org,
        jarkko.sakkinen@linux.intel.com, luto@kernel.org,
        jmorris@namei.org, serge@hallyn.com, paul@paul-moore.com,
        eparis@parisplace.org, jethro@fortanix.com, dave.hansen@intel.com,
        tglx@linutronix.de, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, nhorman@redhat.com,
        pmccallum@redhat.com, serge.ayoun@intel.com,
        shay.katz-zamir@intel.com, haitao.huang@intel.com,
        andriy.shevchenko@linux.intel.com, kai.svahn@intel.com,
        bp@alien8.de, josh@joshtriplett.org, kai.huang@intel.com,
        rientjes@google.com, william.c.roberts@intel.com,
        philip.b.tricca@intel.com
References: <cover.1560131039.git.cedric.xing@intel.com>
 <a382d46f66756e13929ca9244479dd9f689c470e.1560131039.git.cedric.xing@intel.com>
 <b6f099cd-c0eb-d5cf-847d-27a15ac5ceaf@tycho.nsa.gov>
 <20190611220243.GB3416@linux.intel.com>
From:   Stephen Smalley <sds@tycho.nsa.gov>
Message-ID: <8d99d8fb-a921-286a-8cf0-cd522e09b37c@tycho.nsa.gov>
Date:   Thu, 13 Jun 2019 13:02:17 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190611220243.GB3416@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On 6/11/19 6:02 PM, Sean Christopherson wrote:
> On Tue, Jun 11, 2019 at 09:40:25AM -0400, Stephen Smalley wrote:
>> I haven't looked at this code closely, but it feels like a lot of
>> SGX-specific logic embedded into SELinux that will have to be repeated or
>> reused for every security module.  Does SGX not track this state itself?
> 
> SGX does track equivalent state.
> 
> There are three proposals on the table (I think):
> 
>    1. Require userspace to explicitly specificy (maximal) enclave page
>       permissions at build time.  The enclave page permissions are provided
>       to, and checked by, LSMs at enclave build time.
> 
>       Pros: Low-complexity kernel implementation, straightforward auditing
>       Cons: Sullies the SGX UAPI to some extent, may increase complexity of
>             SGX2 enclave loaders.
> 
>    2. Pre-check LSM permissions and dynamically track mappings to enclave
>       pages, e.g. add an SGX mprotect() hook to restrict W->X and WX
>       based on the pre-checked permissions.
> 
>       Pros: Does not impact SGX UAPI, medium kernel complexity
>       Cons: Auditing is complex/weird, requires taking enclave-specific
>             lock during mprotect() to query/update tracking.
> 
>    3. Implement LSM hooks in SGX to allow LSMs to track enclave regions
>       from cradle to grave, but otherwise defer everything to LSMs.
> 
>       Pros: Does not impact SGX UAPI, maximum flexibility, precise auditing
>       Cons: Most complex and "heaviest" kernel implementation of the three,
>             pushes more SGX details into LSMs.
> 
> My RFC series[1] implements #1.  My understanding is that Andy (Lutomirski)
> prefers #2.  Cedric's RFC series implements #3.
> 
> Perhaps the easiest way to make forward progress is to rule out the
> options we absolutely *don't* want by focusing on the potentially blocking
> issue with each option:
> 
>    #1 - SGX UAPI funkiness
> 
>    #2 - Auditing complexity, potential enclave lock contention
> 
>    #3 - Pushing SGX details into LSMs and complexity of kernel implementation
> 
> 
> [1] https://lkml.kernel.org/r/20190606021145.12604-1-sean.j.christopherson@intel.com

Given the complexity tradeoff, what is the clear motivating example for 
why #1 isn't the obvious choice? That the enclave loader has no way of 
knowing a priori whether the enclave will require W->X or WX?  But 
aren't we better off requiring enclaves to be explicitly marked as 
needing such so that we can make a more informed decision about whether 
to load them in the first place?
