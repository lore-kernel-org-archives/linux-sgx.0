Return-Path: <SRS0=W/GT=TR=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1F33C04E87
	for <linux-sgx@archiver.kernel.org>; Fri, 17 May 2019 17:43:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8C0D92173C
	for <linux-sgx@archiver.kernel.org>; Fri, 17 May 2019 17:43:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=tycho.nsa.gov header.i=@tycho.nsa.gov header.b="bVxfgOC7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728853AbfEQRnK (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 17 May 2019 13:43:10 -0400
Received: from usfb19pa12.eemsg.mail.mil ([214.24.26.83]:2561 "EHLO
        USFB19PA12.eemsg.mail.mil" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728810AbfEQRnJ (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Fri, 17 May 2019 13:43:09 -0400
X-EEMSG-check-017: 283120967|USFB19PA12_EEMSG_MP8.csd.disa.mil
Received: from emsm-gh1-uea10.ncsc.mil ([214.29.60.2])
  by USFB19PA12.eemsg.mail.mil with ESMTP/TLS/DHE-RSA-AES256-SHA256; 17 May 2019 17:42:56 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=tycho.nsa.gov; i=@tycho.nsa.gov; q=dns/txt;
  s=tycho.nsa.gov; t=1558114976; x=1589650976;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=re7xKVddD3b86hAv42VQzZ2gdvIV08G5/mdPEZ3wOAo=;
  b=bVxfgOC7qvUB9j1xHv00pib4xHOjieeMBSEOWOpdCFXaAyL0Jm4UcAtV
   tviRT6ejiRPV9vxRp0jnhKAqn9e9vmWimlZNu9b7cKRH+J9TfBYHhslIM
   Qpta8pCxAR7lvEwTdn0PuCorRkeuFYcR1UbuhXgHdxeIdOaAGBZ/wnmlK
   SQyajiF+KMxKZaf0ztsJ+zdU/Ooomw5DzLbIlLwZ23lx4qoiBqwBks8Uq
   lmxjS7NRYBMeWYje71w1ngbCQh4j9/L3j3FjLMvMOO3wXSPRHoH02aIml
   ealGAnToSXzTraGDFHiDXilQ6KBV7SQNsc4BUDeiTSWeU5DhYGeOZkrzq
   g==;
X-IronPort-AV: E=Sophos;i="5.60,480,1549929600"; 
   d="scan'208";a="23844837"
IronPort-PHdr: =?us-ascii?q?9a23=3ASfkvPRcjR+29mosfFa5BHADklGMj4u6mDksu8p?=
 =?us-ascii?q?Mizoh2WeGdxc68ZBWN2/xhgRfzUJnB7Loc0qyK6vmmADRaqs/Y7jgrS99lb1?=
 =?us-ascii?q?c9k8IYnggtUoauKHbQC7rUVRE8B9lIT1R//nu2YgB/Ecf6YEDO8DXptWZBUh?=
 =?us-ascii?q?rwOhBoKevrB4Xck9q41/yo+53Ufg5EmCexbal9IRmrsAndrNQajZd8Jqo+1x?=
 =?us-ascii?q?fFv3pFcPlKyG11Il6egwzy7dqq8p559CRQtfMh98peXqj/Yq81U79WAik4Pm?=
 =?us-ascii?q?4s/MHkugXNQgWJ5nsHT2UZiQFIDBTf7BH7RZj+rC33vfdg1SaAPM32Sbc0WS?=
 =?us-ascii?q?m+76puVRTlhjsLOyI//WrKkcF7kr5Vrwy9qBx+247UYZ+aNPxifqPGYNgWQX?=
 =?us-ascii?q?NNUttNWyBdB4+xaYUAD/AFPe1FsYfzoVUApga6CQW1BO7izjpEi3nr1qM4zu?=
 =?us-ascii?q?shCxnL0hE+EdIAsHrar9v7O6kdXu+30KbGwi7Ob+9V1Drn9ITEbh4srPOKUL?=
 =?us-ascii?q?ltccTR004vFwbdg1uNtYzqISuV1uQTvGid8uFuSOevhHQjqwF1vDeuxtonh4?=
 =?us-ascii?q?7Sho0I0VDJ7jl5wYYpKt24T053e9ikEIBKuC2AOIt2Rd0iTnhutS0nxLMGvp?=
 =?us-ascii?q?u7czILyJQh3xPQdfqHfJSM4h35SuaePy10i297d7KhgRu57EuuyvXkW8Wp31?=
 =?us-ascii?q?tHoTBJn9nRunwXyRDe5daLRuFg8kqnxD2BzRrc6vteLkAxjafbLpkhzaMumZ?=
 =?us-ascii?q?cLqkTDGzP2mF3xjK+LakUo4uio5PrjYrXhvpKcK5V7ihv/MqQzgcyzG/g4Mw?=
 =?us-ascii?q?gSUGib/uSwzrvj8lHiQLpWlPE2l6jZsJTCKcQaoK62HRNV354+5xuwADqqyt?=
 =?us-ascii?q?QVkWQdIF5bdx+LkZLlN0zWLPD9F/i/glCskDlxx/DBO73sGo7NIWXYkLr6Yb?=
 =?us-ascii?q?Z861JTyAo0zdxF4ZJUEasOLOj8Wk/2qtzUFgU5PBCsw+b7FNV90ZsTWXmRDa?=
 =?us-ascii?q?CDNqPeq12I6vgzLOmMfo8VuS39K+Qi5/72jX82h0UdfbKu3ZsRc324H/JmI1?=
 =?us-ascii?q?mHbnromNsODWAKvg8mRuzwlFKCSSJTZ2q1X68k+j40Fp+pDZ3CRo+xmrCA0y?=
 =?us-ascii?q?a7HptZZm1dC1CMF2voeJuAW/sWdC2SJcphmCQeVbe9U48hyQ2utAjixrpjM+?=
 =?us-ascii?q?rU5ioYuIng1Ndr/e3Tkw899ThuA8SayWGNQHl+nnkUSD8uwKB/vUt9x0+B0a?=
 =?us-ascii?q?h9hPxYD8ZT5/JSUgohM57T1el6BM7zWg7bedeJUlmmSM28AT4tVtIx38MOY0?=
 =?us-ascii?q?FlFtW5kB/DxSWqDKEOmryLHpM09qbc3nj3J8pn13nG06whhUE8QsRTLW2mmr?=
 =?us-ascii?q?J/9w/LCo7NkkWZkbuqdKsF0C7W6miM0XeOvFtZUA5sUaTJRHUfZkzLotTk4k?=
 =?us-ascii?q?PNUaSjCaooMgRf086OMKhKZcPzjVVAWvjjPM7SY2Wrm2e/HRyI3K+DbJL2e2?=
 =?us-ascii?q?UB2yXQEFAEnBoO/XaCLgU+Hj2uo3/aDDB3EFLvZETs8fNgp3+hUkA0yASKZV?=
 =?us-ascii?q?V717Wp4h4VmeCcS/QL070aoCcusS90HFem39/NE9qPvRBhfKRHYdMl5FdIz3?=
 =?us-ascii?q?7WuBJnMpynNaBiiUYUcx5rsEP2yxV3FoJAnNAxrHw0yApyKKSY0E5Odj6Dw5?=
 =?us-ascii?q?DwNaPYKnPo8BCsdaHWwFfe38iS+qsV7/Q4sVrjthmzFkU+63Vnz8VV03yE65?=
 =?us-ascii?q?XIFgUSS5HxUkUw9xRgvLHVeCo954DV1X1qL6a0tCTP29YoBOsj1xahcM1TMK?=
 =?us-ascii?q?KCFA/uDcIaA9KiJ/Atm1isdhgEJvxd9LYoP8O6cPuLwKyrM/h8nDKml2RH55?=
 =?us-ascii?q?tw0kyL9ypmVu7HxZAFw/CX3wedSzj8i1KhuNjtmY9YfTESAna/yS/8CYFMfK?=
 =?us-ascii?q?JyY5gEBX2uI8KtwNV+nIDiW3hD+V6iAVMGxNGmeR6IY1Ph2g1Q0FwdoWa7li?=
 =?us-ascii?q?ug0zx0jzYpo7KD3CzBx+TjewEKOmpKRGlkkFfsPZK0j9ccXEipYAkljgaq6l?=
 =?us-ascii?q?jizahBuKt/N3XTQVtPfyXuIGFiSLW/trWZbsFR7pMosztYUOC4YVCbVrHxuQ?=
 =?us-ascii?q?cV0yTmH2FG3jA0aymquonlnxx9kG+dMHFzrGDHec5qwRfQ+cfcSOVV3joHQi?=
 =?us-ascii?q?l4lDbWCkGyP9mu4NWUkYrMvfqiV2KgUZ1TdzPnzYSatCu0/WdqGwGwn+ivmt?=
 =?us-ascii?q?37Fgg3ySv719hsVSXVoxfwe4rr2LqgMeJhYEZoAETx69R1Go5giIs8npIQ1m?=
 =?us-ascii?q?YAhpWT43UHlX3/MdJB2aLxdHANXyIEw8bJ4Aj5301uNn2IyoH4W3iGwctuec?=
 =?us-ascii?q?O6YmUI1SI59cxKD72U7LNclytvvlW4tR7RYeR6njoFzfsu6Xgag/wGuQY01S?=
 =?us-ascii?q?WdDb8TEFJGPSzjiRuI9cqyrKZJa2a1d7i/yk5+kcqmDLGYrQFWQGz5dYs6HS?=
 =?us-ascii?q?9s8sV/N0rB32fw6oH8fdnddtYTthySkxfdgOlZMZwxlv0XhSphJG3yp2Ely+?=
 =?us-ascii?q?88jRxox526u5KHK2p19qKjHhFYLiH1Z98U+jz1i6ZensGW35qqHpp7HDUGR4?=
 =?us-ascii?q?HoQuy1HzISr/vnKxyCHyE7qneeAbDfBxOQ6F96r3LTFJCmL3eXJGEczdp+WB?=
 =?us-ascii?q?aSPkhfgAQJXDU/hZM5DB6ly9HhcEhj+jAd/EL3qhxJyuhwLRnwTn/fpBu0aj?=
 =?us-ascii?q?czUJWfNwRZ7htN50jLK8CR9OJyHyZF/p2ntwGNK2qbZxhWAmENQECLG1fjPr?=
 =?us-ascii?q?y279na7+eYHva+L+fJYbiWsuxeV+2HxJK13otl5TmMKsSOMmBjDvIh30pDXG?=
 =?us-ascii?q?p5Ft/YmzUJVywYiSbNY9SHqxe7/y19ttq//+jzWALz+YuPDKNfMdV19BC3na?=
 =?us-ascii?q?eMLemQiDx5KTZFzJwMw3DIxaMe3F4UlyFhaT2tHa4cui7KSaLagrVXAAIDay?=
 =?us-ascii?q?NvKMtI6Lox0RNLOcHGkNP11755guQuC1dFS1PhhN2mZcwULGG7N1PHA12GNL?=
 =?us-ascii?q?CHJT3N3sH2brmwSbxWjOVIqRKwvSyXHFPkPjSGjzPpTQygMflQjCGHOxxToI?=
 =?us-ascii?q?K9fQxsCWT5V9LmdAe0MN9xjTAtwL00gG/KOnAYMTRmb0xNqbiQ5ztCgvpjA2?=
 =?us-ascii?q?xB8mZlLe6climC9+nVMYwZsf9qAitqkeJX4242xKZL4ytcXvx6hDPSrsJyo1?=
 =?us-ascii?q?GhiuSPyD1nUAFOqjtQhoKLul5iOaXF9plaWHbE5BYN4nuMCxQWvddlDcfvu6?=
 =?us-ascii?q?9IwNjViK3zMCtC887T/cYEBMjbMsOHPGAhMRr0AjHUCgQFQCWqNWHZm0xSjv?=
 =?us-ascii?q?WS+meJoZg9r5jmgIAORaNDVFwpCvMaDVxoHMYDIJhpWDMkjbybg9AT5Xelox?=
 =?us-ascii?q?nRQ8Javp/DVv2MG/ngNDGZjbwXLycPlIj1JIJbHY3h2ld+bUF6kZ7RHEyYCc?=
 =?us-ascii?q?tAqysnbEk/oF9M62R5Vm0+wVnibCus5mMeEbi/mRtg2SVkZuF4zyvh+1c6IB?=
 =?us-ascii?q?LxoSI0lEQg0YH+jSu5bC/6LKD2W5pfTSXzqR5iYdvAXw9pYFjqzgRfPzDeSu?=
 =?us-ascii?q?cU1uYxeA=3D=3D?=
X-IPAS-Result: =?us-ascii?q?A2A8AAAq8d5c/wHyM5BkGwEBAQEDAQEBBwMBAQGBVAMBA?=
 =?us-ascii?q?QELAYFmKoE2BTKEOpMKUAEBBoEILYlOkQIJAQEBAQEBAQEBNAECAQGEQAKCN?=
 =?us-ascii?q?CM3Bg4BAwEBAQQBAQEBAwEBbCiCOikBgmcBBSMPAQVBEAsYAgImAgJXBg0IA?=
 =?us-ascii?q?QGCXz+BdxSqeYEvhUiDKYFGgQwoAYtQF3iBB4ERJ4JrPodOglgEjUSaUgmCD?=
 =?us-ascii?q?YIPkGYGG5YYpBUigVcrCAIYCCEPgyiQbCMDgTYBAY9dAQE?=
Received: from tarius.tycho.ncsc.mil ([144.51.242.1])
  by EMSM-GH1-UEA10.NCSC.MIL with ESMTP; 17 May 2019 17:42:54 +0000
Received: from moss-pluto.infosec.tycho.ncsc.mil (moss-pluto [192.168.25.131])
        by tarius.tycho.ncsc.mil (8.14.4/8.14.4) with ESMTP id x4HHgobW003252;
        Fri, 17 May 2019 13:42:50 -0400
Subject: Re: SGX vs LSM (Re: [PATCH v20 00/28] Intel SGX1 support)
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     "Xing, Cedric" <cedric.xing@intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        James Morris <jmorris@namei.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        LSM List <linux-security-module@vger.kernel.org>,
        Paul Moore <paul@paul-moore.com>,
        Eric Paris <eparis@parisplace.org>,
        "selinux@vger.kernel.org" <selinux@vger.kernel.org>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
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
References: <CALCETrX_Q6qwNRNF0TL2tgfm1j6DKLX7NVHHmWbMFtk3WnHDKw@mail.gmail.com>
 <alpine.LRH.2.21.1905160844130.29250@namei.org>
 <CALCETrX2ovRx3Rre+1_xC-q6CiybyLjQ-gmB4FZF_qCZ-Qd+4A@mail.gmail.com>
 <960B34DE67B9E140824F1DCDEC400C0F654E38CD@ORSMSX116.amr.corp.intel.com>
 <CALCETrUfmyQ7ivNzQic0FyPXe1fmAnoK093jnz0i8DRn2LvdSA@mail.gmail.com>
 <960B34DE67B9E140824F1DCDEC400C0F654E3FB9@ORSMSX116.amr.corp.intel.com>
 <6a97c099-2f42-672e-a258-95bc09152363@tycho.nsa.gov>
 <20190517150948.GA15632@linux.intel.com>
 <ca807220-47e2-5ec2-982c-4fb4a72439c6@tycho.nsa.gov>
 <80013cca-f1c2-f4d5-7558-8f4e752ada76@tycho.nsa.gov>
 <20190517172953.GC15006@linux.intel.com>
From:   Stephen Smalley <sds@tycho.nsa.gov>
Message-ID: <7de94229-f223-64bd-de11-7a601ec26938@tycho.nsa.gov>
Date:   Fri, 17 May 2019 13:42:50 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190517172953.GC15006@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On 5/17/19 1:29 PM, Sean Christopherson wrote:
> On Fri, May 17, 2019 at 12:37:40PM -0400, Stephen Smalley wrote:
>> On 5/17/19 12:20 PM, Stephen Smalley wrote:
>>> On 5/17/19 11:09 AM, Sean Christopherson wrote:
>>>> I think we may want to change the SGX API to alloc an anon inode for each
>>>> enclave instead of hanging every enclave off of the /dev/sgx/enclave
>>>> inode.
>>>> Because /dev/sgx/enclave is NOT private, SELinux's file_map_prot_check()
>>>> will only require FILE__WRITE and FILE__EXECUTE to mprotect() enclave
>>>> VMAs
>>>> to RWX.  Backing each enclave with an anon inode will make SELinux treat
>>>> EPC memory like anonymous mappings, which is what we want (I think), e.g.
>>>> making *any* EPC page executable will require PROCESS__EXECMEM (SGX is
>>>> 64-bit only at this point, so SELinux will always have default_noexec).
>>>
>>> I don't think we want to require EXECMEM (or equivalently both FILE__WRITE
>>> and FILE__EXECUTE to /dev/sgx/enclave) for making any EPC page executable,
>>> only if the page is also writable or previously modified.  The intent is
>>> to prevent arbitrary code execution without EXECMEM (or
>>> FILE__WRITE|FILE__EXECUTE), while still allowing enclaves to be created
>>> without EXECMEM as long as the EPC page mapping is only ever mapped RX and
>>> its initial contents came from an unmodified file mapping that was
>>> PROT_EXEC (and hence already checked via FILE__EXECUTE).
> 
> The idea is that by providing an SGX ioctl() to propagate VMA permissions
> from a source VMA, EXECMEM wouldn't be required to make an EPC page
> executable.  E.g. userspace establishes an enclave in non-EPC memory from
> an unmodified file (with FILE__EXECUTE perms), and the uses the SGX ioctl()
> to copy the contents and permissions into EPC memory.
> 
>> Also, just to be clear, there is nothing inherently better about checking
>> EXECMEM instead of checking both FILE__WRITE and FILE__EXECUTE to the
>> /dev/sgx/enclave inode, so I wouldn't switch to using anon inodes for that
>> reason.  Using anon inodes also unfortunately disables SELinux inode-based
>> checking since we no longer have any useful inode information, so you'd lose
>> out on SELinux ioctl whitelisting on those enclave inodes if that matters.
> 
> The problem is that all enclaves are associated with a single inode, i.e.
> /dev/sgx/enclave.  /dev/sgx/enclave is a char device whose purpose is to
> provide ioctls() and to allow mmap()'ing EPC memory.  In no way is it
> associated with the content that actually gets loaded into EPC memory.
> 
> The actual file that contains the enclave's contents (assuming the enclave
> came from a file) is a separate regular file that the SGX subsystem never
> sees.
> 
> AIUI, having FILE__WRITE and FILE__EXECUTE on /dev/sgx/enclave would allow
> *any* enclave/process to map EPC as RWX.  Moving to anon inodes and thus
> PROCESS__EXECMEM achieves per-process granularity.
> 

No, FILE__WRITE and FILE__EXECUTE are a check between a process and a 
file, so you can ensure that only whitelisted processes are allowed both 
to /dev/sgx/enclave.

