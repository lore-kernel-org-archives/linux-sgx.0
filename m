Return-Path: <SRS0=2c9w=T6=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,T_DKIMWL_WL_HIGH,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A082FC28CC0
	for <linux-sgx@archiver.kernel.org>; Thu, 30 May 2019 14:24:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5308625AD7
	for <linux-sgx@archiver.kernel.org>; Thu, 30 May 2019 14:24:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=tycho.nsa.gov header.i=@tycho.nsa.gov header.b="HiFD7T7m"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726536AbfE3OY6 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 30 May 2019 10:24:58 -0400
Received: from usfb19pa16.eemsg.mail.mil ([214.24.26.87]:2870 "EHLO
        usfb19pa16.eemsg.mail.mil" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725870AbfE3OY5 (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Thu, 30 May 2019 10:24:57 -0400
X-EEMSG-check-017: 199844207|USFB19PA16_EEMSG_MP12.csd.disa.mil
Received: from emsm-gh1-uea11.ncsc.mil ([214.29.60.3])
  by usfb19pa16.eemsg.mail.mil with ESMTP/TLS/DHE-RSA-AES256-SHA256; 30 May 2019 14:22:53 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=tycho.nsa.gov; i=@tycho.nsa.gov; q=dns/txt;
  s=tycho.nsa.gov; t=1559226174; x=1590762174;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=oGy5s0f8/XaojTDy+uR4Svbvd83nDfBgkYCH7AGZk58=;
  b=HiFD7T7meBz/NF0PX/6+sWhpN97b6pxGoJ7dAI75T4q+PRhc603XaFEd
   iZL1OV9vE25fLe8fF1rQzkieb6M2EO+vJ9lCzecRNqeY98LZsmwW9FmRD
   VGU70Vrh+bV5QRUsBwe7HL0ikeWjfGVmBrBCTjhDpMk8g0ytcuAr8HMBg
   sMHs0EEqmOT+q+hQ7gsUqTWtOD5949Qmd2Bx2KYZx00cn8KCAoK3EKzWr
   Dni9hFhVyqsVqT0URMedMuszxhxJ0YDHOTM2Ko7fDMZnaznoJANIrHfh7
   igan3M3O3Fr1Fvxg14CxRrXaDfAeYq5AmF8D4EUi4+FyqPksQ0XSo6A8H
   A==;
X-IronPort-AV: E=Sophos;i="5.60,531,1549929600"; 
   d="scan'208";a="28345768"
IronPort-PHdr: =?us-ascii?q?9a23=3Ak8sJhx/moYLcjf9uRHKM819IXTAuvvDOBiVQ1K?=
 =?us-ascii?q?B91OsXIJqq85mqBkHD//Il1AaPAdyCrase2qGJ7+jJYi8p2d65qncMcZhBBV?=
 =?us-ascii?q?cuqP49uEgeOvODElDxN/XwbiY3T4xoXV5h+GynYwAOQJ6tL1LdrWev4jEMBx?=
 =?us-ascii?q?7xKRR6JvjvGo7Vks+7y/2+94fcbglVmTaxe65+IAuyoAnetMQbjpZpJ7osxB?=
 =?us-ascii?q?fOvnZGYfldy3lyJVKUkRb858Ow84Bm/i9Npf8v9NNOXLvjcaggQrNWEDopM2?=
 =?us-ascii?q?Yu5M32rhbDVheA5mEdUmoNjBVFBRXO4QzgUZfwtiv6sfd92DWfMMbrQ704RS?=
 =?us-ascii?q?iu4qF2QxLzliwJKyA2/33WisxojaJUvhShpwBkw4XJZI2ZLedycr/Bcd8fQ2?=
 =?us-ascii?q?dOUNxRVyhcCY2iaYUBAfcKMeJBo4Xjo1YCqB2zDhSuCuzy0D9FnmL407M00+?=
 =?us-ascii?q?ohEg/I0gIvEN0Mv3vIo9v4L7sSXOOvwaXU0TnOYfFb1DHg44bIaBAhpvSMUK?=
 =?us-ascii?q?ptf8rN10YvDwPFgUuWqYf4Ij2V0/4Cs2yf7+V+VeOklmkqqxpsrTi03coslo?=
 =?us-ascii?q?nIiZ4VylDD7yl5xp01KseiRE50Zt6kDoJduieHPIV1WsMvW3xktSk1x7EcuZ?=
 =?us-ascii?q?O3YTIGxIooyhLBcfCLbo6F6Q/5WumLOzd3nndldaq6hxa17Eev1PXxVtKx0F?=
 =?us-ascii?q?ZWtipFlcTMtmwV2xzT9MeHTvx981+92TmVzQDT6/xEIVsumarHK58u3r4wlp?=
 =?us-ascii?q?0JvUTFAiD2g1n5gLWTdkUl/uik8+XnYrP4qZ+AL4J4lw7zP6s0lsG/HOg0KB?=
 =?us-ascii?q?YCUmeF9eimybHv5Uj5T69Ljv0ynKnZqpfaJcEDq66iHgBVyZ0u6wq/Dji60N?=
 =?us-ascii?q?QYmmMLLFReeB2dlYTpNFbOIO7gAfeln1usiCtrx+zBPrD5HprCMGXMkK3gfb?=
 =?us-ascii?q?lh8UJdxwszzdZQ559PC7EBJu7zVVH1tNDCEhA5NAm0yf79CNphzoMeRX6PAq?=
 =?us-ascii?q?iBPaPJr1CH/OQvL/OOZIMPpDn9K+Il5//1jX8lnl8dZamp0oUNaHCjGfRmJV?=
 =?us-ascii?q?6UYXvqgtcdD2gKuhAyQ/DtiF2HSTRTfWq9X7og5jEnD4KrFZzMRoGpgLyFxi?=
 =?us-ascii?q?u0AodaZnpBCl+XD3jobZmEW+wXZSKdJ89uiD0EVby7R4A90hGusRfwy6B7Ie?=
 =?us-ascii?q?rM5i0YqZXj2cBx5+3OiREy8id5D8eD3GGXSWF7gGcISyUx3KBlrkx30k2D3r?=
 =?us-ascii?q?Rgg/xECdxT4OtEUgUgOp7GzOx6CNfyVhjaftiTS1amQdSmATcvQdI32NIOZ0?=
 =?us-ascii?q?d9G9O/jhHMxSaqArkVl6CVC5ww6K7Tw3/xJ8NlwXbcyKYhl0UmQtdINWC+hK?=
 =?us-ascii?q?5/8g/TB5TTk0WYjKanbqIc0zTI9GidzGqCpkZYUBR/Ua/dR3AQelPWrcjl5k?=
 =?us-ascii?q?PFV7KuEqooMhFOycGcMaZKasfmjVFCRPbjPtTSeX6+m2C1BRyQ3LODcJLqe3?=
 =?us-ascii?q?kB3CXaEEUElwET/XCbNQkxHyuhuHzRAyBzFVL1YkPs7el/pGq+Tk8z0g6Kck?=
 =?us-ascii?q?lh2KSu9x4LivyTVekT0qgHuCg/sTV0Gkiy39bMB9qHvQphc71WYckh71dfyW?=
 =?us-ascii?q?LZqwt9M4S4L694m14edx96v1v02BVqDoVMiM0qrHQtzApoN62Uyk9OdzSd3Z?=
 =?us-ascii?q?roIL3YNnHy/Ayza67RwlzRzs6W9b0V6PQ5sFXupxmpGVA483VmyNlVy3+c6Y?=
 =?us-ascii?q?/WAwUMS57xVVw39xdirbHAfiY9/5/U1WFrMaSsqT/NxdYpBOojyha9cNZSK7?=
 =?us-ascii?q?2EFADsHM0AHcSuK/Ilm0Kvbh0aOOBe7qk0P9mpd/Gewq6kIP5gnC66jWRA+I?=
 =?us-ascii?q?190FyD9zZ8Su7S2JYI2P+Y3gydVzfgllihtMH3mI9eaT4OGWq/zDDuBJRNaa?=
 =?us-ascii?q?1qYYYLFWCuLtWqydpkmZ7iRWRU9F65CFMAw8+mZxySYkf83Q1WyUQYv3inlT?=
 =?us-ascii?q?GkwDxzljEjtrCf0zDWw+T+aBoHPXZGRHVtjVfoLom5lNQaXEmubwg0iBul/0?=
 =?us-ascii?q?H6x65apKVwNWXcXFlHdTDsL25+SquwqqaCY8lX5ZMnqyVYTuu8bEuERb77oR?=
 =?us-ascii?q?sVzSfjH29fxD8nbT2lppL5nxligmKHMHlztGbZed13xRrH+NzcQuRR3iQcSy?=
 =?us-ascii?q?l8lDbXHUOxP92o/dWSipfCvfmyV2ymVp1Odynk0JmPtDe65W1tBx2zhfezms?=
 =?us-ascii?q?foEQIiyy/0y8FqVTnUrBb7eoTr06W6MeR6fkhnHVP86NR1Gpt4koQugJEdwm?=
 =?us-ascii?q?YahpqL8nodi2vzMstU2bj4bHUTQT4H2dnV4BLq2Ed7NHKG25r5VmmBwstmf9?=
 =?us-ascii?q?S7bWAb1yMm4sBJFqiU9rpEkjVxolaiqgLRe/d9lC8HyfQy8H4an/0JuA01wy?=
 =?us-ascii?q?WZA7ASG1RYPCP1mxST4NC/o75aZHigcbeuzkpyh9OhA6+YogFaRnn5fo0uHS?=
 =?us-ascii?q?hq7sVwKFjMymH86pn4eNnMatIergebkxTYj+hQM58xkvsKhSx6OWPypHElxe?=
 =?us-ascii?q?k7jQFo3Z6npoeHN2Rt/KW/AhJCMT31fcwT8Cn3jalChsaWw5yvHpJ5FzUNXJ?=
 =?us-ascii?q?voSuioEDcIuvThLAuOCiMzpWqbGbXFAQ+T8ltpr3XKE5qzLXGYOGEZzcl+RB?=
 =?us-ascii?q?maPEFfhhgUXDAmkZElDA+qwMjhcFp85j0K/F73tAZDyuJyOBnjSGvQuACoaj?=
 =?us-ascii?q?IsQpiFMBVW9h1C51vSMcGG9eJ8ATtY/pK/owCXMGOaZwNIDXwPWkGfBlDjOK?=
 =?us-ascii?q?Wu6sfE8+SCGuW+KP7Oa62UqeNCT/eI2Y6v0ox+8jaXNsWAJHljA+c42kVZQX?=
 =?us-ascii?q?B4Gt3VmjQVRCwSliLNddWWpBa6+i1rsM+/9O7nVx7o5YuKE7FSK8lg+wiqga?=
 =?us-ascii?q?efMO6dnCZ5JixZ1pMQ33DIz6IT3F4Piy50cTmtHq8NtS/LTKLMhKBXCwQXZD?=
 =?us-ascii?q?90NMtN96g8xBVCOdbHitPp0b51luQ6C1FYWlz7m8GoZdYGI3q9NFzZGkaEKL?=
 =?us-ascii?q?SGKiPNw8H0ZqOxUrlQjORStx2ttjeXCU7jPjKflzb3UxCjK/1DjCaePBZGoo?=
 =?us-ascii?q?Gybg5tCXT/TNLhchC7M8V4jTwszb0vmHPFL24cMT5nfkNMqL2Q8T1XgvFlF2?=
 =?us-ascii?q?Nd6XplKPGOmzyF4OnANpYWrfxrDzxvmOJC+3k10b9V7CBaS/xzmybetMNhrE?=
 =?us-ascii?q?++mOmV1jVnSAZOqipMhI+Tv0ViPr7Z9plbVHbG+xIN9mWQCwgQp9tkEt3vv7?=
 =?us-ascii?q?5fysTTlK7pLzdC6d3U99MGB8fIMMKHLGYhMR3xFT7XFgQFTCSnNWHCh0NHlv?=
 =?us-ascii?q?GS+WaYrpk8qpjwhpUOTqVXW0AyFvMfEk5lBsANII9rXjM4lr6WlNQI5Xugox?=
 =?us-ascii?q?nXWMVavI7IVumJDPXgLzaZirZEZx8Wzr/iMYsTMYj7iARebQwwrIXMFA6Ydt?=
 =?us-ascii?q?1BuCxqJEdgq0hB6nl1CH0y3U3NawWx7XtVHvmxyFp+wCB+e+U26DD041otPV?=
 =?us-ascii?q?3M4GMLnUA30fevyWSKfTf3aqX2VoFMCjHosFAxP4ngRABdbAuukEgiPzDBEf?=
 =?us-ascii?q?YZsLpkcWFijUfmvpFCA+JHBflOYRsUg/rRffIi3E5AsQ2owEZG4a3ODp40xy?=
 =?us-ascii?q?Uwdpv5lG5NwwJuapYOIKXUIKdYhgxLirmmoj6j1ud3xhQXYUkK7jXBK2YzpE?=
 =?us-ascii?q?UUO+x+dGKT9et25FnHwmESdQ=3D=3D?=
X-IPAS-Result: =?us-ascii?q?A2DBAgCt5u9c/wHyM5BlGQEBAQEBAQEBAQEBAQcBAQEBA?=
 =?us-ascii?q?QGBZQKBYAUqgW0ohBSTAk8BAQEGgTV+iFKRBwkBAQEBAQEBAQE0AQIBAYFLg?=
 =?us-ascii?q?nUCgn0jOBMBAwEBAQQBAQEBAwEBbChCFgGBYSkBgmYBAQEBAgEjBAsBBUEFC?=
 =?us-ascii?q?wsVAQICAhUCDAMCAkYRBgEMBgIBAYJfP4F3BQ+qKHwzhUeDKIFGgQwoAYtVF?=
 =?us-ascii?q?3iBB4ERJ4I2NT6FGweCLIJYBIs0EoIdhy6ScWoJgg+CFohwiBcGG4IhhmyEA?=
 =?us-ascii?q?YVegwRojHeYFyGBWCsIAhgIIQ87gmyCGxeOPCMDMIEGAQFgiSiBJYJQAQE?=
Received: from tarius.tycho.ncsc.mil ([144.51.242.1])
  by emsm-gh1-uea11.NCSC.MIL with ESMTP; 30 May 2019 14:22:51 +0000
Received: from moss-pluto.infosec.tycho.ncsc.mil (moss-pluto [192.168.25.131])
        by tarius.tycho.ncsc.mil (8.14.4/8.14.4) with ESMTP id x4UEMkXp017261;
        Thu, 30 May 2019 10:22:46 -0400
Subject: Re: SGX vs LSM (Re: [PATCH v20 00/28] Intel SGX1 support)
To:     "Xing, Cedric" <cedric.xing@intel.com>,
        "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
        William Roberts <bill.c.roberts@gmail.com>
Cc:     Andy Lutomirski <luto@kernel.org>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
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
References: <20190524175458.GB365@linux.intel.com>
 <960B34DE67B9E140824F1DCDEC400C0F654E8E1D@ORSMSX116.amr.corp.intel.com>
 <CALCETrUw5sEr-MHPMU4CzEzkrejDs-JOThHB9Buhoxo5-rdpRw@mail.gmail.com>
 <20190524200333.GF365@linux.intel.com>
 <CALCETrUyAAhnQ+RUeN1L41TKj-vcD2CNt-FJ9siO=Zo6gvH1Aw@mail.gmail.com>
 <20190524224107.GJ365@linux.intel.com>
 <683B5E3D-AFB6-4B45-8D39-B00847312209@amacapital.net>
 <960B34DE67B9E140824F1DCDEC400C0F654E965F@ORSMSX116.amr.corp.intel.com>
 <CALCETrXXVMutX8eZk6nnkOAeS+Tj0sQd0FkW+wk6Rx8hQxCe6w@mail.gmail.com>
 <960B34DE67B9E140824F1DCDEC400C0F654E9824@ORSMSX116.amr.corp.intel.com>
 <20190528202407.GB13158@linux.intel.com>
 <285f279f-b500-27f0-ab42-fb1dbcc5ab18@tycho.nsa.gov>
 <960B34DE67B9E140824F1DCDEC400C0F654EB487@ORSMSX116.amr.corp.intel.com>
From:   Stephen Smalley <sds@tycho.nsa.gov>
Message-ID: <678a37af-797d-7bd5-a406-32548a270e3d@tycho.nsa.gov>
Date:   Thu, 30 May 2019 10:22:46 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <960B34DE67B9E140824F1DCDEC400C0F654EB487@ORSMSX116.amr.corp.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On 5/30/19 2:12 AM, Xing, Cedric wrote:
>> From: linux-sgx-owner@vger.kernel.org [mailto:linux-sgx-owner@vger.kernel.org] On Behalf
>> Of Stephen Smalley
>> Sent: Wednesday, May 29, 2019 7:08 AM
>>
>> On 5/28/19 4:24 PM, Sean Christopherson wrote:
>>> On Sat, May 25, 2019 at 11:09:38PM -0700, Xing, Cedric wrote:
>>>>> From: Andy Lutomirski [mailto:luto@kernel.org]
>>>>> Sent: Saturday, May 25, 2019 5:58 PM
>>>>>
>>>>> On Sat, May 25, 2019 at 3:40 PM Xing, Cedric <cedric.xing@intel.com> wrote:
>>>>>>
>>>>>> If we think of EADD as a way of mmap()'ing an enclave file into memory,
>>>>>> would this
>>>>> security_enclave_load() be the same as
>>>>> security_mmap_file(source_vma->vm_file, maxperm, MAP_PRIVATE), except that
>>>>> the target is now EPC instead of regular pages?
>>>>>
>>>>> Hmm, that's clever.  Although it seems plausible that an LSM would want to
>>>>> allow RX or RWX of a given file page but only in the context of an approved
>>>>> enclave, so I think it should still be its own hook.
>>>>
>>>> What do you mean by "in the context of an approved enclave"? EPC pages are
>>>> *inaccessible* to any software until after EINIT. So it would never be a
>>>> security concern to EADD a page with wrong permissions as long as the enclave
>>>> would be denied eventually by LSM at EINIT.
>>>>
>>>> But I acknowledge the difference between loading a page into regular memory
>>>> vs. into EPC. So it's beneficial to have a separate hook, which if not
>>>> hooked, would pass through to security_mmap_file() by default?
>>>
>>> Mapping the enclave will still go through security_mmap_file(), the extra
>>> security_enclave_load() hook allows the mmap() to use PROT_NONE.
>>>
>>>>> If it's going to be in an arbitrary file, then I think the signature needs to be more
>> like:
>>>>>
>>>>> int security_enclave_init(struct vm_area_struct *sigstruct_vma, loff_t
>> sigstruct_offset,
>>>>> const sgx_sigstruct *sigstruct);
>>>>>
>>>>> So that the LSM still has the opportunity to base its decision on the contents of the
>>>>> SIGSTRUCT.  Actually, we need that change regardless.
>>>>
>>>> Wouldn't the pair of { sigstruct_vma, sigstruct_offset } be the same as just
>>>> a pointer, because the VMA could be looked up using the pointer and the
>>>> offset would then be (pointer - vma->vm_start)?
>>>
>>> VMA has vm_file, e.g. the .sigstruct file labeled by LSMs.  That being
>>> said, why does the LSM need the VMA?  E.g. why not this?
>>>
>>>     int security_enclave_init(struct file *file, struct sgx_sigstruct *sigstruct);
>>>
>>>>>> Loosely speaking, an enclave (including initial contents of all of its pages and
>> their
>>>>> permissions) and its MRENCLAVE are a 1-to-1 correspondence (given the collision
>> resistant
>>>>> property of SHA-2). So only one is needed for a decision, and either one would lead to
>> the
>>>>> same decision. So I don't see anything making any sense here.
>>>>>>
>>>>>> Theoretically speaking, if LSM can make a decision at EINIT by means of
>>>>> security_enclave_load(), then security_enclave_load() is never needed.
>>>>>>
>>>>>> In practice, I support keeping both because security_enclave_load() can only approve
>> an
>>>>> enumerable set while security_enclave_load() can approve a non-enumerable set of
>> enclaves.
>>>>> Moreover, in order to determine the validity of a MRENCLAVE (as in development of a
>> policy
>>>>> or in creation of a white/black list), system admins will need the audit log produced
>> by
>>>>> security_enclave_load().
>>>>>
>>>>> I'm confused.  Things like MRSIGNER aren't known until the SIGSTRUCT shows
>>>>> up.  Also, security_enclave_load() provides no protection against loading a
>>>>> mishmash of two different enclave files.  I see security_enclave_init() as
>>>>> "verify this SIGSTRUCT against your policy on who may sign enclaves and/or
>>>>> grant EXECMOD depending on SIGSTRUCT" and security_enclave_load() as
>>>>> "implement your EXECMOD / EXECUTE / WRITE / whatever policy and possibly
>>>>> check enclave files for some label."
>>>>
>>>> Sorry for the confusion. I was saying the same thing except that the decision
>>>> of security_enclave_load() doesn't have to depend on SIGSTRUCT. Given your
>>>> prototype of security_enclave_load(), I think we are on the same page. I made
>>>> the above comment to object to the idea of "require that the sigstruct be
>>>> supplied before any EADD operations so that the maxperm decisions can depend
>>>> on the sigstruct".
>>>
>>> Except that having the sigstruct allows using the sigstruct as the proxy
>>> for the enclave.  I think the last big disconnect is that Andy and I want
>>> to tie everything to an enclave-specific file, i.e. sigstruct, while you
>>> are proposing labeling /dev/sgx/enclave.  If someone wants to cram several
>>> sigstructs into a single file, so be it, but using /dev/sgx/enclave means
>>> users can't do per-enclave permissions, period.
>>>
>>> What is your objection to working on the sigstruct?
>>>
>>>>>>>> Passing both would allow tying EXECMOD to /dev/sgx/enclave as
>>>>>>>> Cedric wanted (without having to play games and pass
>>>>>>>> /dev/sgx/enclave to security_enclave_load()), but I don't think
>>>>>>>> there's anything fundamentally broken with using .sigstruct for
>>>>>>>> EXECMOD.  It requires more verbose labeling, but that's not a bad thing.
>>>>>>>
>>>>>>> The benefit of putting it on .sigstruct is that it can be per-enclave.
>>>>>>>
>>>>>>> As I understand it from Fedora packaging, the way this works on
>>>>>>> distros is generally that a package will include some files and
>>>>>>> their associated labels, and, if the package needs EXECMOD, then the
>>>>>>> files are labeled with EXECMOD and the author of the relevant code might get a dirty
>>>>> look.
>>>>>>>
>>>>>>> This could translate to the author of an exclave that needs RWX
>>>>>>> regions getting a dirty look without leaking this permission into other enclaves.
>>>>>>>
>>>>>>> (In my opinion, the dirty looks are actually the best security
>>>>>>> benefit of the entire concept of LSMs making RWX difficult.  A
>>>>>>> sufficiently creative attacker can almost always bypass W^X
>>>>>>> restrictions once they’ve pwned you, but W^X makes it harder to pwn
>>>>>>> you in the first place, and SELinux makes it really obvious when
>>>>>>> packaging a program that doesn’t respect W^X.  The upshot is that a
>>>>>>> lot of programs got fixed.)
>>>>>>
>>>>>> I'm lost here. Dynamically linked enclaves, if running on SGX2, would need RW->RX,
>> i.e.
>>>>> FILE__EXECMOD on /dev/sgx/enclave. But they never need RWX, i.e. PROCESS__EXECMEM.
>>>>>
>>>>> Hmm.  If we want to make this distinction, we need something a big richer
>>>>> than my proposed callbacks.  A check of the actual mprotect() / mmap()
>>>>> permissions would also be needed.  Specifically, allowing MAXPERM=RWX
>>>>> wouldn't imply that PROT_WRITE | PROT_EXEC is allowed.
>>>
>>> Actually, I think we do have everything we need from an LSM perspective.
>>> LSMs just need to understand that sgx_enclave_load() with a NULL vma
>>> implies a transition from RW.  For example, SELinux would interpret
>>> sgx_enclave_load(NULL, RX) as requiring FILE__EXECMOD.
>>>
>>> As Cedric mentioned earlier, the host process doesn't necessarily know
>>> which pages will end up RW vs RX, i.e. sgx_enclave_load(NULL, RX)
>>> already has to be invoked at runtime, and when that happens, the kernel
>>> can take the opportunity to change the VMAs from MAY_RW to MAY_RX.
>>>
>>> For simplicity in the kernel and clarity in userspace, it makes sense to
>>> require an explicit ioctl() to add the to-be-EAUG'd range.  That just
>>> leaves us wanting an ioctl() to set the post-EACCEPT{COPY} permissions.
>>>
>>> E.g.:
>>>
>>>       ioctl(<prefix>_ADD_REGION, { NULL }) /* NULL == EAUG, MAY_RW */
>>>
>>>       mprotect(addr, size, RW);
>>>       ...
>>>
>>>       EACCEPTCOPY -> EAUG /* page fault handler */
>>>
>>>       ioctl(<prefix>_ACTIVATE_REGION, { addr, size, RX}) /* MAY_RX */
>>>
>>>       mprotect(addr, size, RX);
>>>
>>>       ...
>>>
>>> And making ACTIVATE_REGION a single-shot per page eliminates the need for
>>> the MAXPERMS concept (see below).
>>>
>>>> If we keep only one MAXPERM, wouldn't this be the current behavior of
>>>> mmap()/mprotect()?
>>>>
>>>> To be a bit more clear, system admin sets MAXPERM upper bound in the form of
>>>> FILE__{READ|WRITE|EXECUTE|EXECMOD} of /dev/sgx/enclave. Then for a
>>>> process/enclave, if what it requires falls below what's allowed on
>>>> /dev/sgx/enclave, then everything will just work. Otherwise, it fails in the
>>>> form of -EPERM returned from mmap()/mprotect(). Please note that MAXPERM here
>>>> applies to "runtime" permissions, while "initial" permissions are taken care
>>>> of by security_enclave_{load|init}. "initial" permissions could be more
>>>> permissive than "runtime" permissions, e.g., RX is still required for initial
>>>> code pages even though system admins could disable dynamically loaded code
>>>> pages by *not* giving FILE__{EXECUTE|EXECMOD}. Therefore, the "initial"
>>>> mapping would still have to be done by the driver (to bypass LSM), either via
>>>> a new ioctl or as part of IOC_EINIT.
>>>
>>> Aha!
>>>
>>> Starting with Cedric's assertion that initial permissions can be taken
>>> directly from SECINFO:
>>>
>>>     - Initial permissions for *EADD* pages are explicitly handled via
>>>       sgx_enclave_load() with the exact SECINFO permissions.
>>>
>>>     - Initial permissions for *EAUG* are unconditionally RW.  EACCEPTCOPY
>>>       requires the target EPC page to be RW, and EACCEPT with RO is useless.
>>>
>>>     - Runtime permissions break down as follows:
>>>         R   - N/A, subset of RW (EAUG)
>>>         W   - N/A, subset of RW (EAUG) and x86 paging can't do W
>>>         X   - N/A, subset of RX (x86 paging can't do XO)
>>>         RW  - Handled by EAUG LSM hook (uses RW unconditionally)
>>>         WX  - N/A, subset of RWX (x86 paging can't do WX)
>>>         RX  - Handled by ACTIVATE_REGION
>>>         RWX - Handled by ACTIVATE_REGION
>>>
>>> In other words, if we define the SGX -> LSM calls as follows (minus the
>>> file pointer and other params for brevity):
>>>
>>>     - <prefix>_ACTIVATE_REGION(vma, perms) -> sgx_enclave_load(NULL, perms)
>>>
>>>     - <prefix>_ADD_REGION(vma) -> sgx_enclave_load(vma, SECINFO.perms)
>>>
>>>     - <prefix>_ADD_REGION(NULL) -> sgx_enclave_load(NULL, RW)
>>>
>>> then SGX and LSMs have all the information and hooks needed.  The catch
>>> is that the LSM semantics of sgx_enclave_load(..., RW) would need to be
>>> different than normal shared memory, e.g. FILE__WRITE should *not* be
>>> required, but that's ok since it's an SGX specific hook.  And if for some
>>> reason an LSM wanted to gate access to EAUG *without* FILE__EXECMOD, it'd
>>> have the necessary information to do so.
>>
>> Assuming that sgx_enclave_load() is a LSM hook (probably named
>> security_enclave_load() instead), then:
>>
>> a) Does the sigstruct file get passed to this hook in every case, even
>> when vma is NULL?  I think the answer is yes, just want to confirm.
> 
> I'm confused.

I'm finding it difficult to follow as well, so my questions are just an 
attempt to understand the latest model.

> In the case of EADD (non-NULL vma), are we passing both vma and sigstruct file? If so, which file dictates allowed permissions, vma->vm_file or sigstruct, or both???

My impression was that they were going to pass both, but the sigstruct 
file is the target of permission checks.  The vma if non-NULL would be 
used to determine whether PROT_EXEC is being added or was already 
present and whether EXECMOD needs to be checked (i.e. copy-on-write has 
occurred and PROT_EXEC is being added).

> In the case of EAUG (NULL vma), all other parameters are constant for any given enclave. Then why do we call this same hook for every region added, assuming the hook will return the same value everytime anyway?

Yes, I was wondering about that as well.

> And it looks like ACTIVATE_REGION is needed only because the proposed security_enclave_load() would base its decision on the sigstruct file. An alternative is to base that decision on /dev/sgx/enclave. Of course the former has finer granularity but is that really necessary? From security perspective, only the weakest link matters. FILE__EXECMOD on a regular shared object could allow exploits of all bugs throughout the host process because code within that shared object is modifiable by not only itself but also any code within that same process. In contrast, FILE__EXECMOD on /dev/sgx/enclave only allows enclaves to modify themselves. They cannot modify each other, neither can "untrusted" code outside of enclaves modify any of them. So it doesn't look like a weaker link to me. Moreover, requiring FILE__EXECMOD on sigstruct means it could be used as a target buffer for code injection attacks. IMHO that *lowers* the security of the whole process.

This is partly why I suggested separate ENCLAVE__EXECMOD and other 
checks below, so we can distinguish between FILE__EXECMOD versus 
ENCLAVE__EXECMOD on the sigstruct file.  If using /dev/sgx/enclave as 
the target, then we don't need a separate permission per se but we lose 
the per-sigstruct granularity.

> 
>>
>> b) Should we use a different hook for ACTIVATE_REGION than for
>> ADD_REGION or is the distinction between them irrelevant/unnecessary
>> from an access control point of view? At present LSM/SELinux won't be
>> able to distinguish ACTIVATE_REGION(vma, RW) from ADD_REGION(NULL) above
>> since they will both invoke the same hook with the same arguments IIUC.
>> Does it matter?  It's ok if the answer is no, just want to confirm.
>>
>> c) Is there still also a separate security_enclave_init() hook that will
>> be called, and if so, how does it differ and when is it called relative
>> to security_enclave_load()?
> 
> I think security_enclave_init() will always be useful, as it offers a way for LSM to implement whitelisting/blacklisting. Of course an LSM module like SELinux can look into the backing inode too. I think the hook should have a signature like:
> 
> int security_enclave_init(struct sgx_sigstruct __user *sigstruct);
> 
> An LSM that cares about the backing file could look into vm_file of the VMA covering the buffer, while an LSM that cares the sigstruct itself (e.g. signing key) could just look into the buffer.

I'm not a fan of passing __user pointers to LSM hooks.  And it certainly 
shouldn't be looking at the buffer since it could change between the 
time of check and time of use.

> 
>>
>> d) What checks were you envisioning each of these calls making?
>>
>> With the separate security_enclave_*() hooks, we could define and use
>> new ENCLAVE__* permissions, e.g. ENCLAVE__LOAD, ENCLAVE__INIT,
>> ENCLAVE__EXECUTE, ENCLAVE__EXECMEM, ENCLAVE__EXECMOD, if we want to
>> distinguish these operations from regular file mmap/mprotect operations.
> 
> I'm not sure if these ENCLAVE__* flags are an overkill, unless we want to enforce an enclave file cannot be loaded as a regular shared object or vice versa.

ENCLAVE__LOAD and/or ENCLAVE__INIT would be to support whitelisting of 
what enclaves can be loaded/initialized by the process.  That's separate 
from the W^X discussion.  Those permissions would be between the process 
and either the sigstruct file or the enclave file (the consensus seemed 
to be the sigstruct file as the stronger/more complete binding of the 
enclave).  We probably only need one of those two permission checks not 
both.

ENCLAVE__EXECUTE, ENCLAVE__EXECMEM, ENCLAVE__EXECMOD would allow 
distinctions between host process mmap/mprotect PROT_EXEC operations 
(which would continue to apply FILE__EXECUTE, PROCESS__EXECMEM, and 
FILE__EXECMOD checks if appropriate) and the driver's setting of initial 
and runtime permissions (which would apply ENCLAVE__EXECUTE, 
ENCLAVE__EXECMEM, and ENCLAVE__EXECMOD checks if appropriate). That's 
particularly helpful if we are using the sigstruct or enclave file as 
the target of all checks instead of /dev/sgx/enclave, so that we don't 
have to allow FILE__EXECUTE or FILE__EXECMOD to the sigstruct file by 
the host process.

> 
>>
>>>
>>> The userspace changes are fairly minimal:
>>>
>>>     - For SGX1, use PROT_NONE for the initial mmap() and refactor ADD_PAGE
>>>       to ADD_REGION.
>>>
>>>     - For SGX2, do an explicit ADD_REGION on the ranges to be EAUG'd, and an
>>>       ACTIVATE_REGION to make a region RX or R (no extra ioctl() required to
>>>       keep RW permissions).
>>>
>>> Because ACTIVATE_REGION can only be done once per page, to do *abitrary*
>>> mprotect() transitions, userspace would need to set the added/activated
>>> permissions to be a superset of the transitions, e.g. RW -> RX would
>>> require RWX, but that's a non-issue.
>>>
>>>     - For SGX1 it's a nop since it's impossible to change the EPCM
>>>       permissions, i.e. the page would need to be RWX regardless.
>>>
>>>     - For SGX2, userspace can suck it up and request RWX to do completely
>>>       arbitrary transitions (working as intended), or the kernel can support
>>>       trimming (removing) pages from an enclave, which would allow userspace
>>>       to do "arbitrary" transitions by first removing the page.
>>>
> 

