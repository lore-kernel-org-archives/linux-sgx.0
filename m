Return-Path: <SRS0=b5m/=TW=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E62E0C282CE
	for <linux-sgx@archiver.kernel.org>; Wed, 22 May 2019 13:56:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A3E5F21473
	for <linux-sgx@archiver.kernel.org>; Wed, 22 May 2019 13:56:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=tycho.nsa.gov header.i=@tycho.nsa.gov header.b="PcuFhzfu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728370AbfEVN4m (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 22 May 2019 09:56:42 -0400
Received: from ucol19pa10.eemsg.mail.mil ([214.24.24.83]:9928 "EHLO
        UCOL19PA10.eemsg.mail.mil" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726770AbfEVN4l (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Wed, 22 May 2019 09:56:41 -0400
X-EEMSG-check-017: 678690706|UCOL19PA10_EEMSG_MP8.csd.disa.mil
X-IronPort-AV: E=Sophos;i="5.60,499,1549929600"; 
   d="scan'208";a="678690706"
Received: from emsm-gh1-uea10.ncsc.mil ([214.29.60.2])
  by UCOL19PA10.eemsg.mail.mil with ESMTP/TLS/DHE-RSA-AES256-SHA256; 22 May 2019 13:56:38 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=tycho.nsa.gov; i=@tycho.nsa.gov; q=dns/txt;
  s=tycho.nsa.gov; t=1558533399; x=1590069399;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=EbYf9ZJ5ydiQRU2r91F4Jt2Wejkf+cUQo/5Tro5IduY=;
  b=PcuFhzfuZL8x+xM0DDe0/cmEJk/xodfZnI2rwnmBe4JXMWtvyjUbbaCw
   e8UGpFu3H63IS8RqiHCaN4pkcIVjbYVmnGySYXtf/ZOBpDVp4fAPQqN1Y
   BEZH73xsB43BQHfeNC5qv/vk/xrivsmxWw7lC0IqO4fl2NtLJ5PidpO3s
   foWudK0zs9cydjsB8DHzbYflxGSCXcnjCacdX4QaSCG2CU6AiENwl8JDE
   f05odx6b/2dIGjOmX6Fro8bOJJOQzdAp5ROq3zr3V9YHRrht44PgiBLzF
   nX9ILGbFsEiektTfAFn7nhI65xMKPZeSGl52L4NabdvJoDbw7DhsSmV1K
   g==;
X-IronPort-AV: E=Sophos;i="5.60,499,1549929600"; 
   d="scan'208";a="23976963"
IronPort-PHdr: =?us-ascii?q?9a23=3AChLVCx3RCgD91IhYsmDT+DRfVm0co7zxezQtwd?=
 =?us-ascii?q?8ZsegQKvXxwZ3uMQTl6Ol3ixeRBMOHsqsC0rOM+P6xEUU7or+5+EgYd5JNUx?=
 =?us-ascii?q?JXwe43pCcHRPC/NEvgMfTxZDY7FskRHHVs/nW8LFQHUJ2mPw6arXK99yMdFQ?=
 =?us-ascii?q?viPgRpOOv1BpTSj8Oq3Oyu5pHfeQpFiCegbb9oMRm6sBvdusYXjIZmN6081g?=
 =?us-ascii?q?bHrnxUdupM2GhmP0iTnxHy5sex+J5s7SFdsO8/+sBDTKv3Yb02QaRXAzo6PW?=
 =?us-ascii?q?814tbrtQTYQguU+nQcSGQWnQFWDAXD8Rr3Q43+sir+tup6xSmaIcj7Rq06VD?=
 =?us-ascii?q?i+86tmTgLjhTwZPDAl7m7Yls1wjLpaoB2/oRx/35XUa5yROPZnY6/RYc8WSW?=
 =?us-ascii?q?9HU8lfTSxBBp63YZUJAeQPIO1Uq5DxqlsKoBe7AwSnGeHhxSJShnLuwKM0ze?=
 =?us-ascii?q?ohHwHF0gIuEd0Bv3bbo8n6OqoJTeC4zrPFwSnfY/5Y2zrw7pXDfBA7ofGLWL?=
 =?us-ascii?q?J9adffyVUxGAPdjlWft4rlNC6I2OQIqWeb6+5gWvyvimU6rAxxuSWgxtw3h4?=
 =?us-ascii?q?nVhoMa1lDE9SJjzIYzPt23UlR3YdGjEJtOriyXMZZ9TMA6Q2xwpSo3xbILtY?=
 =?us-ascii?q?S7cSQX0pgr2RHSZ+Kdf4SV5B/oSfyfLi1ihH1/fbKynxOy8U+9xeLiTsS0y1?=
 =?us-ascii?q?NKrjZdktnLq3ANywTf6siZRft5+UeswSqP2BrJ6uFFPEA0jrDXK4Ihw7Eslp?=
 =?us-ascii?q?oTtl7PHinql0XtkKCabEAk+ums6+j/Y7XmoIGTN5Nshw3jPakjldazDOQlPg?=
 =?us-ascii?q?QUQWSW9vqw2Kf+8UHhRbVFlPw2kq3XsJDAIsQbo7a0AxRI3YY48Bu/Ezen38?=
 =?us-ascii?q?gYnXkANl5FfgmHgJLzN1HBJ/D4E++zg06wnzdz2/DGIrrhD43PLnfZirfhfr?=
 =?us-ascii?q?V960lGxAoo199f5JFUCrAHIP3tXE/8r9jYDh4/MwypzOfrEtR91oUCWW2RBq?=
 =?us-ascii?q?+VKr/dsViN5ug3OemDeJcVuCrhK/gi//PulmE2lkUbfaWz35sbcmy3HvR8I0?=
 =?us-ascii?q?WYenrsntABEX8KvgUgVuzqk1qCUThIanazWaI8+i80CIa8AYjfQYCthaSL3D?=
 =?us-ascii?q?2nEZ1OemBGFleMHG/sd4WZR/cMbzmfIsx/nTweU7iuVYsh2QuptA/gxLptNv?=
 =?us-ascii?q?DU9TEAtZL/yNh14PXelRM39TxzFcSdyWCNT3pvk2MOXTA22b5woU1nxleEy6?=
 =?us-ascii?q?h4jORSFcZP6PNRTgc6KZncwvRhC9/sQALBccmGRU2mQtq8BTExStIww9kUb0?=
 =?us-ascii?q?lhHNWiiwjJ3zC2DL8Ni7yLGJs0/7rY33jwIcZ91nnH2LA6j1Y4XsRPKHemhq?=
 =?us-ascii?q?9j9wnTHoLJlkKZmLu3daQYwiHA73mDzWWQs0FCSgJwUrvKXWoZZkTIqdT1/E?=
 =?us-ascii?q?TCT6WhCb4/KAtO1daCKrdWat3ulVhGXO3sOMnaY2+qg2e/HwuIxreVYIrvfG?=
 =?us-ascii?q?Ud2z/dB1Yenw8P+naGMBA0Bj29rGLGEDxuCVXvblvy/ulmsny7VE40zxqRYk?=
 =?us-ascii?q?15zbW14B8VheeES/MXxL0LpDkupy9zHFan0NLcE8CAqBZ5fKVAfdM9509K1X?=
 =?us-ascii?q?nHuAx5P5ygKb1ih1EFfgRpsEPhyQ93Bp9Dkcc0tnMqyhR9KaaC3FNGbTOY0o?=
 =?us-ascii?q?j6OqfLJWnq4BCvd6nW10nc0NmI5qcP6O44q1L4sQGnEUoi6Wln3MNT03ud6Z?=
 =?us-ascii?q?TGFhYdUZX0Ukwv7Rh1u6naYjUh54PTzXBjLbe7vSLY29IoGOQp0Bmhf9ZZMK?=
 =?us-ascii?q?OLDwLyEssaB9SwJ+wugVSmchUEPOVK/q4uI8ymb+eG2LKsPOt4gT2pl3pH75?=
 =?us-ascii?q?5n3kKM7SV8TPXI0IgDw/yD3wuHUSv8g0mlsszthY9EYjQSFHKlySf4HI5Rer?=
 =?us-ascii?q?FyfYETBGeyLM23wtp/ioXpW35Z8l6jGk8G2NWueRqUblz80hdc2lkJrna/gy?=
 =?us-ascii?q?u30yR0ky01rqqYxCHOzP7iewQIOmNQWmZii1XsLpawj9AeXUincxIlmwei5U?=
 =?us-ascii?q?b/36JbvrhwL3HPQUdUeCj7N31iUqyqtrqcecFP7I4nsT5MXeS4YFCaTKP9oh?=
 =?us-ascii?q?QD3yPtGGte2TY7eCywtZXlnhx6j2SdIGx0rHrDdsF63Q3f68DERf5NwjoGQz?=
 =?us-ascii?q?F1iT3WBli6Itmo8syYl5TdveCkUWKuSJlTfDL1zYOPqiS7/3dmAR6hkPCpnN?=
 =?us-ascii?q?3oDww63TX819lwWiXCtAz8bZXz16SmLeJneVFlBVD/5sd7AYx+kZU/hIsW2X?=
 =?us-ascii?q?cEgpWZ530HkX38Md9Dw6LxcGINRSIXw97S+AXl3ExjLnSUx4P2T3md2cRhZt?=
 =?us-ascii?q?ahb2MI1SIy8dpKBL2X7LNahyt1pES3rQbLbfh6hDcdxuMk6GQGjOERpAot0i?=
 =?us-ascii?q?KdD6gIEklbJSzskg+F79S/rKVReWaufqG81ER5ndC8CrGNvxtTWGr4epclGy?=
 =?us-ascii?q?989MJ/MEjD0Hfr8IHrZMHQbc4Pth2TixrAiehVKJUrlvoPnyVnP3nwvWc7xO?=
 =?us-ascii?q?EmjRxhx426sJKbJGVq+aKzGgRYOSHtZ8MP5jHtir5TnsCO34CqAppuBi8EXJ?=
 =?us-ascii?q?/sTfK1FTIfru7nOBiTHz08sHibBaDTEhOY6Edjt3jPCYykN2mLJHkFytVvXA?=
 =?us-ascii?q?KdK1JFgAAbQjo2hIQ2FwCtxMz8dkd0/TER5ljkqhRSzuJkLQXwUmDapA2wcD?=
 =?us-ascii?q?c7VICfLAZK7gFF/0rVKsye4fhzHi1C/Z2uthCNK22CawVJF24JX02EB0r4M7?=
 =?us-ascii?q?mv49nA7/aXBu6kI/TSZrWOrPRUV+2UypK3zotm4zGMO92PPnZ4Dv07xlBMXX?=
 =?us-ascii?q?djF8TZhjUAUSoXly3WYs6aohe85jN4rsSl/Pv3XwLv4JOFC6FOPtV35xC2na?=
 =?us-ascii?q?CDOvaKiyZ/NDlYzJIMxH/SxLgE3F4dlT9ueCWtEbsesy7NT6XQl7RTDx4abS?=
 =?us-ascii?q?NzKcRJ47g93glLJc7UlNf12qRkgf4yDldPTUbhld2xZcwWP2G9M0vKBEWRO7?=
 =?us-ascii?q?SHPzHL2N/3brm8Sb1Wl+hUthuwuSqFHE/nJDiMiz7pVxW3O+FWkC6bJABeuJ?=
 =?us-ascii?q?26cht1EmfjVMnrZQe/MN92kzI2x745imnXOmECKTJ8aV9CrqWM7SNEhfVyA2?=
 =?us-ascii?q?5B7n1+LemEgCuZ7e7YKo0Wsft3GCR0lvpa4HAkxLtJ8CFIXvt1mDHdrtR2uV?=
 =?us-ascii?q?GpjvGPyiZ7UBpJsjtLh5iEvUR4NaXZ65lPQ3DE/B0W4GWRDRQKu8VqCtn1t6?=
 =?us-ascii?q?9MzdjPkbr5KC1e/NLM4cscG8/UJdqdMHogLxXpHiLUDAkbQj6wLmzfiEtdkP?=
 =?us-ascii?q?ad9n2RsJc2sITjmJ0LSuwTaFtgNPoACUdiVOcLI5R2WD4i2eqZhdQL5n34tx?=
 =?us-ascii?q?DSR8Rcs5bvUvOUHOWpKTCFgL0CbBwNl/ewFokaMMXQ21ZjcUV9hITHAVHXW5?=
 =?us-ascii?q?gZuSBoaEk25k5N6nllUmor20//cQSryH4VCfOw2BUxj10tT/4q8WLX/1ovJl?=
 =?us-ascii?q?fM7BA1mU01lMSt1SudaxbtPaywWsdQECOyuE8vZMCoCz1pZBG/yBQ3fAzPQK?=
 =?us-ascii?q?hc2v45KDFm?=
X-IPAS-Result: =?us-ascii?q?A2BGAAAwU+Vc/wHyM5BlHAEBAQQBAQcEAQGBUwUBAQsBg?=
 =?us-ascii?q?WEFKoE7MoQ7k1oGgTWJTo8JgXsJAQEBAQEBAQEBNAECAQGEQAKCMSM2Bw4BA?=
 =?us-ascii?q?wEBAQQBAQEBAwEBbCiCOikBgmcBBSMEETQKAxALGAICJgICVwYBDAgBAYJfP?=
 =?us-ascii?q?4F3FKgsfDOFR4MkgUaBDCgBi1AXeIEHgREngms+h06CWASNToV9lGYJgg+CE?=
 =?us-ascii?q?ZBvBhuWMoxdl1MNJIFXKwgCGAghD4MokGwjA4E2AQGNagEB?=
Received: from tarius.tycho.ncsc.mil ([144.51.242.1])
  by EMSM-GH1-UEA10.NCSC.MIL with ESMTP; 22 May 2019 13:56:38 +0000
Received: from moss-pluto.infosec.tycho.ncsc.mil (moss-pluto [192.168.25.131])
        by tarius.tycho.ncsc.mil (8.14.4/8.14.4) with ESMTP id x4MDuUko015996;
        Wed, 22 May 2019 09:56:30 -0400
Subject: Re: SGX vs LSM (Re: [PATCH v20 00/28] Intel SGX1 support)
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Andy Lutomirski <luto@kernel.org>,
        James Morris <jmorris@namei.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        LSM List <linux-security-module@vger.kernel.org>,
        Paul Moore <paul@paul-moore.com>,
        Eric Paris <eparis@parisplace.org>, selinux@vger.kernel.org,
        Jethro Beekman <jethro@fortanix.com>,
        "Xing, Cedric" <cedric.xing@intel.com>,
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
References: <20190514204527.GC1977@linux.intel.com>
 <CALCETrX6aL367mMJh5+Y1Seznfu-AvhPV6P7GkWF4Dhu0GV8cw@mail.gmail.com>
 <20190515013031.GF1977@linux.intel.com>
 <CALCETrXf8mSK45h7sTK5Wf+pXLVn=Bjsc_RLpgO-h-qdzBRo5Q@mail.gmail.com>
 <20190517000331.GD11204@linux.intel.com>
 <CALCETrWxw7xALE0kmiYBzomaSMAeXEVq-7rX7xeqPtDPeDQiCA@mail.gmail.com>
 <20190520114105.GD27805@linux.intel.com>
 <20190521151836.GA4843@linux.intel.com>
 <20190521155140.GE22089@linux.intel.com>
 <20190522132022.GC31176@linux.intel.com>
 <20190522132227.GD31176@linux.intel.com>
From:   Stephen Smalley <sds@tycho.nsa.gov>
Message-ID: <0e183cce-c4b4-0e10-dbb6-bd81bea58b66@tycho.nsa.gov>
Date:   Wed, 22 May 2019 09:56:30 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190522132227.GD31176@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On 5/22/19 9:22 AM, Jarkko Sakkinen wrote:
> On Wed, May 22, 2019 at 04:20:22PM +0300, Jarkko Sakkinen wrote:
>> On Tue, May 21, 2019 at 08:51:40AM -0700, Sean Christopherson wrote:
>>> Except that mmap() is more or less required to guarantee that ELRANGE
>>> established by ECREATE is available.  And we want to disallow mmap() as
>>> soon as the first EADD is done so that userspace can't remap the enclave's
>>> VMAs via munmap()->mmap() and gain execute permissions to pages that were
>>> EADD'd as NX.
>>
>> We don't want to guarantee such thing and it is not guaranteed. It does
>> not fit at all to the multi process work done. Enclaves are detached
>> from any particular process addresse spaces. It is responsibility of
>> process to open windows to them.
>>
>> That would be completely against work that we've done lately.
> 
> Example use case: you have a process that just constructs an enclave
> and sends it to another process or processes for use. The constructor
> process could have basically anything on that range. This was the key
> goal of the fd based enclave work.

What exactly happens in the constructor versus the recipient processes? 
Which process performs each of the necessary open(), mmap(), and ioctl() 
calls for setting up the enclave?  Can you provide a high level overview 
of the sequence of userspace calls by the constructor and by the 
recipient similar to what Sean showed earlier for just a single process?
