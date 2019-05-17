Return-Path: <SRS0=W/GT=TR=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F418C04AB4
	for <linux-sgx@archiver.kernel.org>; Fri, 17 May 2019 18:16:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D68782087B
	for <linux-sgx@archiver.kernel.org>; Fri, 17 May 2019 18:16:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=tycho.nsa.gov header.i=@tycho.nsa.gov header.b="cP7NVaoK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729210AbfEQSQU (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 17 May 2019 14:16:20 -0400
Received: from ucol19pa14.eemsg.mail.mil ([214.24.24.87]:64142 "EHLO
        ucol19pa14.eemsg.mail.mil" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728305AbfEQSQU (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Fri, 17 May 2019 14:16:20 -0400
X-EEMSG-check-017: 706659040|UCOL19PA14_EEMSG_MP12.csd.disa.mil
X-IronPort-AV: E=Sophos;i="5.60,480,1549929600"; 
   d="scan'208";a="706659040"
Received: from emsm-gh1-uea10.ncsc.mil ([214.29.60.2])
  by ucol19pa14.eemsg.mail.mil with ESMTP/TLS/DHE-RSA-AES256-SHA256; 17 May 2019 18:16:13 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=tycho.nsa.gov; i=@tycho.nsa.gov; q=dns/txt;
  s=tycho.nsa.gov; t=1558116973; x=1589652973;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=+Nr/ea0LVvf2SH/YGtchwepdBQO9XHrskL5uTjGZl5s=;
  b=cP7NVaoKBN72VqZenfJQ+F2WBe5TmAFH85s8fbspeJHAFN/1eSD8ZtjN
   janwlEIk0gBSCe3cjOVCtnzSSIcELAWSAH0tTzBU+oPdRaChvE2o5lPJx
   JddkjW7uuMsPf2hpXgsUBEq3sqEgnlNbShfBV9zGBzm8Hpm/35S48YFJb
   /me8ZkYnP7ZdwOO8DPSwC9wNlx4QwsooUv/X6OfsQFqVCqznsflUQvEWN
   UDpg4QMiRf3Tru/ZHpHc+yh9zZ5CZgIm0GwgGulWVEYPHWqdHMpZAHZzl
   I1Z6ykmZ5cRqSUdztXMYHGvo6byAxFGYSvQkt25NR/kllFXf3QmILjpVI
   A==;
X-IronPort-AV: E=Sophos;i="5.60,480,1549929600"; 
   d="scan'208";a="23846762"
IronPort-PHdr: =?us-ascii?q?9a23=3AQsCCpB+hZponVv9uRHKM819IXTAuvvDOBiVQ1K?=
 =?us-ascii?q?B91uwXIJqq85mqBkHD//Il1AaPAdyCrasc0aGP6fuocFdDyK7JiGoFfp1IWk?=
 =?us-ascii?q?1NouQttCtkPvS4D1bmJuXhdS0wEZcKflZk+3amLRodQ56mNBXdrXKo8DEdBA?=
 =?us-ascii?q?j0OxZrKeTpAI7SiNm82/yv95HJbAhEmSexbalvIBmqswndudQajZVsJ60s1h?=
 =?us-ascii?q?bHv3xEdvhMy2h1P1yThRH85smx/J5n7Stdvu8q+tBDX6vnYak2VKRUAzs6PW?=
 =?us-ascii?q?874s3rrgTDQhCU5nQASGUWkwFHDBbD4RrnQ5r+qCr6tu562CmHIc37SK0/VD?=
 =?us-ascii?q?q+46t3ThLjlTwKPCAl/m7JlsNwjbpboBO/qBx5347Ue5yeOP5ncq/AYd8WWW?=
 =?us-ascii?q?9NU8BfWCxbBoO3cpUBAewPM+1Fq4XxvlsDoB+7CQSqGejhyCJHhmXu0KMnze?=
 =?us-ascii?q?ohHwHI0g8uEd0Av3vbrsn6OqgJXOCpzqTF1ynPY+9Y1Dr/7oXDbxAvoeuLXb?=
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
X-IPAS-Result: =?us-ascii?q?A2AbAACU+d5c/wHyM5BkGwEBAQEDAQEBBwMBAQGBUwQBA?=
 =?us-ascii?q?QELAYFmKoE7MoQ6kwtQAQEGgQgtiU6PB4F7CQEBAQEBAQEBATQBAgEBhEACg?=
 =?us-ascii?q?jQjNgcOAQMBAQEEAQEBAQMBAWwogjopAYJmAQEBAQIBIxVBBQsLGAICJgICV?=
 =?us-ascii?q?wYNCAEBgl8/gXcFD6sMgS+FSIMogUaBDCgBi1AXeIEHgREngms+h06CWASNR?=
 =?us-ascii?q?IV8lFYJgg2CD5BmBhuWGKQGDSSBVysIAhgIIQ+DKJBsIwOBNgEBj10BAQ?=
Received: from tarius.tycho.ncsc.mil ([144.51.242.1])
  by EMSM-GH1-UEA10.NCSC.MIL with ESMTP; 17 May 2019 18:16:12 +0000
Received: from moss-pluto.infosec.tycho.ncsc.mil (moss-pluto [192.168.25.131])
        by tarius.tycho.ncsc.mil (8.14.4/8.14.4) with ESMTP id x4HIGBqr015987;
        Fri, 17 May 2019 14:16:11 -0400
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
References: <CALCETrX2ovRx3Rre+1_xC-q6CiybyLjQ-gmB4FZF_qCZ-Qd+4A@mail.gmail.com>
 <960B34DE67B9E140824F1DCDEC400C0F654E38CD@ORSMSX116.amr.corp.intel.com>
 <CALCETrUfmyQ7ivNzQic0FyPXe1fmAnoK093jnz0i8DRn2LvdSA@mail.gmail.com>
 <960B34DE67B9E140824F1DCDEC400C0F654E3FB9@ORSMSX116.amr.corp.intel.com>
 <6a97c099-2f42-672e-a258-95bc09152363@tycho.nsa.gov>
 <20190517150948.GA15632@linux.intel.com>
 <ca807220-47e2-5ec2-982c-4fb4a72439c6@tycho.nsa.gov>
 <80013cca-f1c2-f4d5-7558-8f4e752ada76@tycho.nsa.gov>
 <20190517172953.GC15006@linux.intel.com>
 <7de94229-f223-64bd-de11-7a601ec26938@tycho.nsa.gov>
 <20190517175036.GD15006@linux.intel.com>
From:   Stephen Smalley <sds@tycho.nsa.gov>
Message-ID: <ce087f3c-2a78-ce37-c764-a3ca233e7057@tycho.nsa.gov>
Date:   Fri, 17 May 2019 14:16:11 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190517175036.GD15006@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On 5/17/19 1:50 PM, Sean Christopherson wrote:
> On Fri, May 17, 2019 at 01:42:50PM -0400, Stephen Smalley wrote:
>> On 5/17/19 1:29 PM, Sean Christopherson wrote:
>>> AIUI, having FILE__WRITE and FILE__EXECUTE on /dev/sgx/enclave would allow
>>> *any* enclave/process to map EPC as RWX.  Moving to anon inodes and thus
>>> PROCESS__EXECMEM achieves per-process granularity.
>>>
>>
>> No, FILE__WRITE and FILE__EXECUTE are a check between a process and a file,
>> so you can ensure that only whitelisted processes are allowed both to
>> /dev/sgx/enclave.
> 
> Ah, so each process has its own FILE__* permissions for a specific set of
> files?

That's correct.

> Does that allow differentiating between a process making an EPC page RWX
> and a process making two separate EPC pages RW and RX?

Not if they are backed by the same inode, nor if they are all backed by 
anon inodes, at least not as currently implemented.
