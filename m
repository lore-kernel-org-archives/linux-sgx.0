Return-Path: <SRS0=W/GT=TR=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62B38C04AB4
	for <linux-sgx@archiver.kernel.org>; Fri, 17 May 2019 16:37:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1DCDC2082E
	for <linux-sgx@archiver.kernel.org>; Fri, 17 May 2019 16:37:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=tycho.nsa.gov header.i=@tycho.nsa.gov header.b="lKph/pfc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727160AbfEQQh6 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 17 May 2019 12:37:58 -0400
Received: from ucol19pa13.eemsg.mail.mil ([214.24.24.86]:14603 "EHLO
        ucol19pa13.eemsg.mail.mil" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726238AbfEQQh5 (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Fri, 17 May 2019 12:37:57 -0400
X-EEMSG-check-017: 711456560|UCOL19PA13_EEMSG_MP11.csd.disa.mil
X-IronPort-AV: E=Sophos;i="5.60,480,1549929600"; 
   d="scan'208";a="711456560"
Received: from emsm-gh1-uea10.ncsc.mil ([214.29.60.2])
  by ucol19pa13.eemsg.mail.mil with ESMTP/TLS/DHE-RSA-AES256-SHA256; 17 May 2019 16:37:52 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=tycho.nsa.gov; i=@tycho.nsa.gov; q=dns/txt;
  s=tycho.nsa.gov; t=1558111072; x=1589647072;
  h=subject:from:to:cc:references:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=uh8cGqICRyx8vtpbM3N+JiKZuqvrfcKJ5l7mZM3EJyA=;
  b=lKph/pfccvvTt2L75dpQVJ+ZG5/R7J0KmtMhxJIDCQgZE+QDJ+6vUM+5
   pomrYZnmWD6amITRarfw4JKJIS9vllgOHRBSsA6AzigYoGSyKjU8VACRj
   CCRyYtwPGdFgROzQ10Qud26MhRALgECmNYRF7ABPabEVt4nndbiN9iSj+
   ueuIsufIUYccQ8KjWbUx+jVnaLlLzDmrLEsayjzlE70GYHPqtGoX22/93
   15cu4hFiYNcN9XuwG7oEb+z680nTc2NXO3Mn8X4IAECASs6vX+ZGBPtlS
   9j7+8iXa6dGUiFz7GhBG620iKUm1NteBR52BS9dlAZwJP4C34Ts9xN9w8
   A==;
X-IronPort-AV: E=Sophos;i="5.60,480,1549929600"; 
   d="scan'208";a="23841440"
IronPort-PHdr: =?us-ascii?q?9a23=3A/qn6sB+b9m8G1P9uRHKM819IXTAuvvDOBiVQ1K?=
 =?us-ascii?q?B91uwXIJqq85mqBkHD//Il1AaPAdyCrasc0aGP6/mocFdDyK7JiGoFfp1IWk?=
 =?us-ascii?q?1NouQttCtkPvS4D1bmJuXhdS0wEZcKflZk+3amLRodQ56mNBXdrXKo8DEdBA?=
 =?us-ascii?q?j0OxZrKeTpAI7SiNm82/yv95HJbAhEmSexbalvIBmqswndudQajZd/Jq0s1h?=
 =?us-ascii?q?bHv3xEdvhMy2h1P1yThRH85smx/J5n7Stdvu8q+tBDX6vnYak2VKRUAzs6PW?=
 =?us-ascii?q?874s3rrgTDQhCU5nQASGUWkwFHDBbD4RrnQ5r+qCr6tu562CmHIc37SK0/VD?=
 =?us-ascii?q?q+46t3ThLjlTwKPCAl/m7JlsNwjbpboBO/qBx5347Ue5yeOP5ncq/AYd8WWW?=
 =?us-ascii?q?9NU8BfWCxbBoO3cpUBAewPM+1Fq4XxvlsDoB+7CQSqGejhyCJHhmXu0KMn0+?=
 =?us-ascii?q?ovDw/G0g8uEd0Av3vbrsn6OqgJXOCpz6TF1ynPY+9Y1Dr/7oXDbxAvoeuLXb?=
 =?us-ascii?q?J1acff1FUvGB3djlWQt4PlOS6e2PkIs2eB6+pgUfygim46oAx2uTig29wsh5?=
 =?us-ascii?q?LVhoMV1l/E9SJ5zJwzJd2jUkF3e9GkEJxOtyyDMYZ9X8AsQ3lwtSonxbALto?=
 =?us-ascii?q?S3cSgXxJg92RLSZOKLf5KV7h/lSe2fOy13hGh/d7K6nxuy9E+gxfDiWcSsy1?=
 =?us-ascii?q?ZKqzZFksHLtnAQyxzf8siHReV5/kemwTuPyxrc6vtFIUApjqrXMYIhw74smZ?=
 =?us-ascii?q?oTtkTPBCn2l1ntjKCKbEkk/+mo6+D/brXnoJ+TKZN0hxnjPqkhlcGzG+Q1Ph?=
 =?us-ascii?q?UUU2SF9umwyqfv8VDhTLVPlPI2k63ZsJ7AJcQco660GxRV3Zs46xukEzen0M?=
 =?us-ascii?q?gXnXkALF5ffhKHlJLmN0vBIPD/E/ezm06snytzx/DaIr3hBY3ALmPdn7j7e7?=
 =?us-ascii?q?Zx8UxcxBAvwtBf/ZJUC6oBIO70Wk/ptNzXEAU5Mxezw+bhE9h914UeWX6RDa?=
 =?us-ascii?q?+dKq/drViI5uc3KemWeIAVoCr9K+Qi5/P2kXA2h0ISfbOo3ZQLcny5EfVmI0?=
 =?us-ascii?q?OWYXf3g9cBF3sKsRQ6TODwlFKCVjtTbW6oX60g/jE7FJ6mDYDbS4CpnbyBwC?=
 =?us-ascii?q?C7E4ZVZm9YEFCMF2nnd4GeV/cLciKSLddrkiYYWri5V48hyRauuRf4y7piKe?=
 =?us-ascii?q?rU4DcYtZP41NVu4e3cjxQy+iJ1D8iH1GGNVW50lHsSRzAqxKB/vVB9ylCb3K?=
 =?us-ascii?q?hjnfNYD9NT6O1SXwc6L5Hcy+h6CtD0Wg7bYtiJT1OmSM28AT4tVtIx38MOY0?=
 =?us-ascii?q?FlFtWmjxDD2TeqArAMm7yQGpM77r/c32LwJ8Zhy3fKzawhj147TctSMW2pmL?=
 =?us-ascii?q?Vy9xbcB4HXiUWVjaWqeroG3C7L6miDyXCCvEZCUA5/Sa/FR2wQZlPKrdTl4U?=
 =?us-ascii?q?PPV6euBq46MgtF0sOCMrFFasDtjVlfQffjP9PeY3ivlGuqGRmIwbaMZpLwe2?=
 =?us-ascii?q?oBxCXdFFQEkwcL8HmYLQgxHD2ho2PFDDF1DVLgeVns8ehlqHOjSk871R2FYF?=
 =?us-ascii?q?N727qy4B4ViuSWS+kP0bIcpCchtzJ0EU6m393ID9qApgxhfLhTYN4m/ldH2n?=
 =?us-ascii?q?zWtxZnMpyjMa9inFgefBpzv0/00BV3EIpAm9AwrHw21ApyNb6Y0FRZejOax5?=
 =?us-ascii?q?/wIL7XKmr1/By1cK7ZwFLe0NWX+qcJ9vs4rU7uvAWoFkok7nVm3MNZ03qa5p?=
 =?us-ascii?q?XWEgUSVYj9XVow9xh/v7vaeDUy55vI1X1wNqm5qj3C1Mw1BOsl0BageMxSMK?=
 =?us-ascii?q?2DFA/oD80VHc6uKO0lmlSzch0EO+VS/rYuP8y6b/uGxLKrPOF4kT27l2tH/p?=
 =?us-ascii?q?5y3liM9yVmTO7IxIgKw/eD0wuGUTf8kEmussTtlY9YYjESG3K1yTL4C45Jeq?=
 =?us-ascii?q?1yYYELBH+yI824wtV/iIXgW3pZ9F6lGlMGxNWpeR2Ub1z80gxcz1kYrmK/ky?=
 =?us-ascii?q?ui0zN0iy0prraY3CHWzOTibgQIOmFQSWZ8i1fsI5a7j9QeXEipcwcljgeq5U?=
 =?us-ascii?q?H/x6JDvqRwM3HTQVtUfyjxN2xiTqywtqCcY8FV7JMnrD5XXf+4YVCbTL79vh?=
 =?us-ascii?q?Qb3zrtH2tZ2TA7cSyltY/lnxx7j2KdKmx/rH3DecF/3R3f/sDTReZN3joaQy?=
 =?us-ascii?q?l1kT3XBlm6P9m08tSYjpTDvf6kV2KnSJJTdTLmzZ2PtCSl/21mGx6/kO6pmt?=
 =?us-ascii?q?3hDwc61TX3195wVSXHtBz8eJXk17ymMeJ7eUllHFD95sl7F4xlkYs/mosQ2X?=
 =?us-ascii?q?4EiZWR53YHln3zMdpD06LkcHUNXSILw8LS4AX93E1jL3SJx5/2V3mE2cthaN?=
 =?us-ascii?q?a7b3gI2iIy8c9KEr2Y7L9akitvpFq3swbRbeJ6njcHxvsk8GQajP0RuAox0i?=
 =?us-ascii?q?WdBagfElNbPSz0khSF9NS+rKRRZGayfrm8zUR+nde8DLGEvw5TQmr5epYlHS?=
 =?us-ascii?q?929Ml/N0jM0HLr4IH+ZNbQdc4TtgGTkxrYiehVKJUxluAPhSV9P2LwpmclxP?=
 =?us-ascii?q?Amghxux566oJKLJHlq/KK8GhRYLCH6Z9sP+jHxiqZThsCW35iqHpp9BjoERp?=
 =?us-ascii?q?/oTfa1EDIXrvnnLRiBHyA8qniBBbrTBxOQ6EBjr3jXCZCkK2mXJGUFzdVlXB?=
 =?us-ascii?q?SdP1JQgBobXDokhJI2DACrxMv8cEd//T0R51j4qgdSxeJsLRXwTmDfpAKwYD?=
 =?us-ascii?q?cuVJefNAZW7h1F50rNKsye7vh8HiFC8p2itgONNm2aax1JDG4TX0yEBkrjM6?=
 =?us-ascii?q?Kv5dnG7+iXGO6+I+HSbrWJrOxUT+2Iyo630ot64zaMMd2CPnl4AP06xkpMR3?=
 =?us-ascii?q?d5F97ZmzUSUSMXkS3NYtWapBe65i14sMS//O73VwLo4IuFE6FSPsl3+xCqna?=
 =?us-ascii?q?eDMPadizx/KTlFzJMMxH/JxKIE3F4SlS5uaSWiEbQeui7LT6LQnbRaDxoaay?=
 =?us-ascii?q?N1KctJ4Lgw3ghLOc7HlNz10qR0geIyC1dATVbhgN2mZdQWI2GhM1PKHEWLO6?=
 =?us-ascii?q?6HJTHR2MH3f7mzSb1WjOhPth2wvyqbHFHnPjiZizbpUBWvO/lWjC6HJBxepJ?=
 =?us-ascii?q?29chF1BGf4VNLrcQe0MNt2jTIox705hWnGOnMCPjJkaUNCsqWQ7T9EgvV4A2?=
 =?us-ascii?q?FB7H1lLfKEmyuC7enYLY0Wsft3AiRuluJa+HA6xKVJ7CFYXvB1nzHSrtF2qV?=
 =?us-ascii?q?G8juaP0iZnUAZJqjtTh4KEp0RiNb/Z9pldQ3nE+h0N4H6RCxQMu9tqFNnvt7?=
 =?us-ascii?q?pMxdjIkaL5MC1C/M7M/csAG8jUL9qKMGAgMRX3Hj7UEAkFQiCwNWzEiExdl/?=
 =?us-ascii?q?aS9nKRrpcksJTjhJ0OSroIHGAyQ8gXA0ItN9wYIYxrWSsknKSAi8hAsWGzpR?=
 =?us-ascii?q?+XRoNRvorGTe6VGfXiMi2ei5FFYQcFxfXzKoFFZaPh3Ek3UUV3hITHHQLrWN?=
 =?us-ascii?q?lJpiBwJlsvrF5l7Gl1Tmp13VnsLAyq/ilARraPghcqh14mMqwW/zD27gJyfw?=
 =?us-ascii?q?ebqQ=3D=3D?=
X-IPAS-Result: =?us-ascii?q?A2ByAAAA4t5c/wHyM5BkGgEBAQEBAgEBAQEHAgEBAQGBZ?=
 =?us-ascii?q?YFnKoE2BAEyhDqTCk0BAQEBAQaBCAgliU6RAgkBAQEBAQEBAQE0AQIBAYRAA?=
 =?us-ascii?q?oI0IzgTAQMBAQEEAQEBAQMBAWwogjopAYJnAQUjDwEFQRALGAICJgICVwYNC?=
 =?us-ascii?q?AEBgl8/gXcUqleBL4hvgUaBDCiLURd4gQeBOAyCXz6HToJYBI1EmlIJgg2CD?=
 =?us-ascii?q?5BmBhuWGKQWIYFXKwgCGAghD4MokGwjA4E2AQGOegEB?=
Received: from tarius.tycho.ncsc.mil ([144.51.242.1])
  by EMSM-GH1-UEA10.NCSC.MIL with ESMTP; 17 May 2019 16:37:42 +0000
Received: from moss-pluto.infosec.tycho.ncsc.mil (moss-pluto [192.168.25.131])
        by tarius.tycho.ncsc.mil (8.14.4/8.14.4) with ESMTP id x4HGbeFV010684;
        Fri, 17 May 2019 12:37:40 -0400
Subject: Re: SGX vs LSM (Re: [PATCH v20 00/28] Intel SGX1 support)
From:   Stephen Smalley <sds@tycho.nsa.gov>
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
References: <20190515013031.GF1977@linux.intel.com>
 <CALCETrXf8mSK45h7sTK5Wf+pXLVn=Bjsc_RLpgO-h-qdzBRo5Q@mail.gmail.com>
 <alpine.LRH.2.21.1905160543070.19802@namei.org>
 <CALCETrX_Q6qwNRNF0TL2tgfm1j6DKLX7NVHHmWbMFtk3WnHDKw@mail.gmail.com>
 <alpine.LRH.2.21.1905160844130.29250@namei.org>
 <CALCETrX2ovRx3Rre+1_xC-q6CiybyLjQ-gmB4FZF_qCZ-Qd+4A@mail.gmail.com>
 <960B34DE67B9E140824F1DCDEC400C0F654E38CD@ORSMSX116.amr.corp.intel.com>
 <CALCETrUfmyQ7ivNzQic0FyPXe1fmAnoK093jnz0i8DRn2LvdSA@mail.gmail.com>
 <960B34DE67B9E140824F1DCDEC400C0F654E3FB9@ORSMSX116.amr.corp.intel.com>
 <6a97c099-2f42-672e-a258-95bc09152363@tycho.nsa.gov>
 <20190517150948.GA15632@linux.intel.com>
 <ca807220-47e2-5ec2-982c-4fb4a72439c6@tycho.nsa.gov>
Message-ID: <80013cca-f1c2-f4d5-7558-8f4e752ada76@tycho.nsa.gov>
Date:   Fri, 17 May 2019 12:37:40 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <ca807220-47e2-5ec2-982c-4fb4a72439c6@tycho.nsa.gov>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On 5/17/19 12:20 PM, Stephen Smalley wrote:
> On 5/17/19 11:09 AM, Sean Christopherson wrote:
>> On Fri, May 17, 2019 at 09:53:06AM -0400, Stephen Smalley wrote:
>>> On 5/16/19 6:23 PM, Xing, Cedric wrote:
>>>> I thought EXECMOD applied to files (and memory mappings backed by 
>>>> them) but
>>>> I was probably wrong. It sounds like EXECMOD applies to the whole 
>>>> process so
>>>> would allow all pages within a process's address space to be 
>>>> modified then
>>>> executed, regardless the backing files. Am I correct this time?
>>>
>>> No, you were correct the first time I think; EXECMOD is used to control
>>> whether a process can make executable a private file mapping that has
>>> previously been modified (e.g. text relocation); it is a special case to
>>> support text relocations without having to allow full EXECMEM (i.e. 
>>> execute
>>> arbitrary memory).
>>>
>>> SELinux checks relevant to W^X include:
>>>
>>> - EXECMEM: mmap/mprotect PROT_EXEC an anonymous mapping (regardless of
>>> PROT_WRITE, since we know the content has to have been written at some
>>> point) or a private file mapping that is also PROT_WRITE.
>>> - EXECMOD: mprotect PROT_EXEC a private file mapping that has been
>>> previously modified, typically for text relocations,
>>> - FILE__WRITE: mmap/mprotect PROT_WRITE a shared file mapping,
>>> - FILE__EXECUTE: mmap/mprotect PROT_EXEC a file mapping.
>>>
>>> (ignoring EXECSTACK and EXECHEAP here since they aren't really 
>>> relevant to
>>> this discussion)
>>>
>>> So if you want to ensure W^X, then you wouldn't allow EXECMEM for the
>>> process, EXECMOD by the process to any file, and the combination of both
>>> FILE__WRITE and FILE__EXECUTE by the process to any file.
>>>
>>> If the /dev/sgx/enclave mappings are MAP_SHARED and you aren't using an
>>> anonymous inode, then I would expect that only the FILE__WRITE and
>>> FILE__EXECUTE checks are relevant.
>>
>> Yep, I was just typing this up in a different thread:
>>
>> I think we may want to change the SGX API to alloc an anon inode for each
>> enclave instead of hanging every enclave off of the /dev/sgx/enclave 
>> inode.
>> Because /dev/sgx/enclave is NOT private, SELinux's file_map_prot_check()
>> will only require FILE__WRITE and FILE__EXECUTE to mprotect() enclave 
>> VMAs
>> to RWX.  Backing each enclave with an anon inode will make SELinux treat
>> EPC memory like anonymous mappings, which is what we want (I think), e.g.
>> making *any* EPC page executable will require PROCESS__EXECMEM (SGX is
>> 64-bit only at this point, so SELinux will always have default_noexec).
> 
> I don't think we want to require EXECMEM (or equivalently both 
> FILE__WRITE and FILE__EXECUTE to /dev/sgx/enclave) for making any EPC 
> page executable, only if the page is also writable or previously 
> modified.  The intent is to prevent arbitrary code execution without 
> EXECMEM (or FILE__WRITE|FILE__EXECUTE), while still allowing enclaves to 
> be created without EXECMEM as long as the EPC page mapping is only ever 
> mapped RX and its initial contents came from an unmodified file mapping 
> that was PROT_EXEC (and hence already checked via FILE__EXECUTE).

Also, just to be clear, there is nothing inherently better about 
checking EXECMEM instead of checking both FILE__WRITE and FILE__EXECUTE 
to the /dev/sgx/enclave inode, so I wouldn't switch to using anon inodes 
for that reason.  Using anon inodes also unfortunately disables SELinux 
inode-based checking since we no longer have any useful inode 
information, so you'd lose out on SELinux ioctl whitelisting on those 
enclave inodes if that matters.
