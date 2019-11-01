Return-Path: <SRS0=mxub=YZ=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBB4FCA9ECF
	for <linux-sgx@archiver.kernel.org>; Fri,  1 Nov 2019 13:28:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8C0FD20862
	for <linux-sgx@archiver.kernel.org>; Fri,  1 Nov 2019 13:28:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=tycho.nsa.gov header.i=@tycho.nsa.gov header.b="n1jHVFny"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727166AbfKAN2f (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 1 Nov 2019 09:28:35 -0400
Received: from UHIL19PA36.eemsg.mail.mil ([214.24.21.195]:56285 "EHLO
        UHIL19PA36.eemsg.mail.mil" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726860AbfKAN2e (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Fri, 1 Nov 2019 09:28:34 -0400
X-EEMSG-check-017: 44435321|UHIL19PA36_ESA_OUT02.csd.disa.mil
X-IronPort-AV: E=Sophos;i="5.68,255,1569283200"; 
   d="scan'208";a="44435321"
Received: from emsm-gh1-uea10.ncsc.mil ([214.29.60.2])
  by UHIL19PA36.eemsg.mail.mil with ESMTP/TLS/DHE-RSA-AES256-SHA256; 01 Nov 2019 13:28:32 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=tycho.nsa.gov; i=@tycho.nsa.gov; q=dns/txt;
  s=tycho.nsa.gov; t=1572614913; x=1604150913;
  h=subject:from:to:cc:references:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=pm+yb6daALQUOqbHLY0/Ix6RJnAc3VPwtcdxpR8hGm0=;
  b=n1jHVFnyBFT+Y5rkraNDx/kA64pS9xJa3Xb0N8g+dPjrarZ/wyE4/A+k
   64E8msXODGpagFKnQtdF5lLaYLLtZe62/fHiqP30Qih8HKohPCLlJ9rOK
   CMwCAzplYt1Bvw/Myz9kuwl8Yzly0TzYpttk3IrWc8X0vgZinVjNBTxbH
   ZrH+sq6FvL94BXjh5e7aKXrcTKhs03AamSYPHdy2srQGpxeT/NpMpvGlh
   k4eCJbzATQ+FkRAFXiha0R8HwlX7CZPARBUEbHfVYKWTj9NnfKNRAAGz2
   vY2evNXcw5WX50jv6n4NkoJFsYYzN28bALaVpJcrpU3S2xTtuW+bteYTD
   A==;
X-IronPort-AV: E=Sophos;i="5.68,255,1569283200"; 
   d="scan'208";a="29653569"
IronPort-PHdr: =?us-ascii?q?9a23=3A8Ik+Rx3PPQgJEMQZsmDT+DRfVm0co7zxezQtwd?=
 =?us-ascii?q?8ZsegULPrxwZ3uMQTl6Ol3ixeRBMOHsqkC0rKJ+Py9EUU7or+5+EgYd5JNUx?=
 =?us-ascii?q?JXwe43pCcHRPC/NEvgMfTxZDY7FskRHHVs/nW8LFQHUJ2mPw6arXK99yMdFQ?=
 =?us-ascii?q?viPgRpOOv1BpTSj8Oq3Oyu5pHfeQpFiCezbL9oMRm6sQfcusYZjIZiN6081g?=
 =?us-ascii?q?bHrnxUdupM2GhmP0iTnxHy5sex+J5s7SFdsO8/+sBDTKv3Yb02QaRXAzo6PW?=
 =?us-ascii?q?814tbrtQTYQguU+nQcSGQWnQFWDAXD8Rr3Q43+sir+tup6xSmaIcj7Rq06VD?=
 =?us-ascii?q?i+86tmTgLjhTwZPDAl7m7Yls1wjLpaoB2/oRx/35XUa5yROPZnY6/RYc8WSW?=
 =?us-ascii?q?9HU8lfTSxBBp63YZUJAeQPIO1Uq5DxqlUKoBe7AwSnGeHhxSJShnLuwKM00/?=
 =?us-ascii?q?ovEQ/F0gIuEd0Bv3bbo8n6OqoJTeC4z7PFwSnfY/5Y2zrw7pXDfBA7ofGLWL?=
 =?us-ascii?q?J9adffyVUxGAPdjlWft4rlNC6I2OQIqWeb6+5gWvyvimU6rAxxuSWgxtw3h4?=
 =?us-ascii?q?nVhoMa1lDE9SJjzIYzPt23UlR3YdGjEJtOriyXMZZ9TM0lQ2Ftoik6y7sGtI?=
 =?us-ascii?q?a4fCcU0pQnwQDQa/idf4iP+BLjW+CcKip7inJ9YL+zmhm//Ee6xuD8S8W4yk?=
 =?us-ascii?q?hGoyVbntXWq3wA0QHY5NKdRftn5Eih3C6C1wXU6u5ZP085jbHbK5s9wr4okZ?=
 =?us-ascii?q?oTrFjDEjf2mEroiK+WcV0p+vSy5OT9Y7Xmu4ScO5VoigD+Lqsumsu/Df4+Mg?=
 =?us-ascii?q?cSRGiU5f6w1Lji/U39WLlKj/s2nbfFsJ3COMgWqaG0DxVV34o+8RqzETir3M?=
 =?us-ascii?q?oCkXUaNF5FfQiIj4ntO1HAOvD4CvK/jky3kDh23PDLJaHhA5XRIXjDl7ftZ7?=
 =?us-ascii?q?B961VGxwYpwtBf4IxUBqkbIP3vQk/xqMDYDhghPgy22ennEtZ91oAZWW6VGa?=
 =?us-ascii?q?+WKqDSsVyJ5uIpPeaMYpQYuDL8K/gj+v7vgmU1mV4bfam1w5QXbGq0EehhI0?=
 =?us-ascii?q?WceXDsmMsOEX8WvgoiS+znkFmCUT9VZ3avUKMw/zI7B5y8DYfFWI+thKeM3D?=
 =?us-ascii?q?m0HpJIfGBKEFOMHmnyd4WCRfgMbDieIsh7kjwLTbKhUZMu1QmytA/mzLpqNu?=
 =?us-ascii?q?XV9y4ZuJ/419h6+ffTlRcs+jxwFcid1HuNT25slGMSWzA2xLx/oVB6ylqb1a?=
 =?us-ascii?q?h4gvpYFcFc5v9QSQc6OpHdwvdkC9D9RA3BZM2FSFW4TdW8BzE+UNYxz8UJY0?=
 =?us-ascii?q?ZnFNWolgrD0DayA78Ji7yLA4Q5/bjf33jpIsZw0HLG1Kgnj1k7TcpDLGOmhq?=
 =?us-ascii?q?li9wjVGoHGiVmZl6etdaQaxiLN832DzWWWtkFCTAFwSbnFXWwYZkbOsNv2/F?=
 =?us-ascii?q?3CQKG0BbQnKARBz9WCJbVMatDyjFVGQuvjN8raY26rh2iwAhOIzKuWbIX2Y2?=
 =?us-ascii?q?UdwDndCE8cngAI43mJLw4+Cj2jo27EEDNuFUjvY0L38elir3O7Vk80wB+Qb0?=
 =?us-ascii?q?160Lq1/AUYhf2aS/MPwL0EvD0tpClzHFa4x9jWEcaPpxJ9fKVAZtMw+FFH1W?=
 =?us-ascii?q?LetwxnO5yvNaZii0UEcwtpokzu1w94Cplancc2q3MqyRJ4KbiE31NZazOYwZ?=
 =?us-ascii?q?fwN6XRKmnq+RCgd7LZ1Uva0NaS56cP7e81q0/9sw60Fkot6Wln38NJ3Hub45?=
 =?us-ascii?q?XAFBASXo7pUkYr6xh6oKnXYjIj6IPO2n1jL7O4vSXC2tIuGeslzA2tf9ZZMK?=
 =?us-ascii?q?OYCgDyF9cWCNSpKOwvg1KpdA4LPPhO9K4oOMOrb+CG2K6xM+dghj6mjn5I4J?=
 =?us-ascii?q?x8006V9itzUOvI35cfw/yD3wuHUSv8g0mlsszthY9EYjQSFHKlySf4HI5Rer?=
 =?us-ascii?q?FyfYETBGeuOcK3x8l+iITqW3JC9F6jGkkJ2MmmeReJblz92xFQ2loToXC9hS?=
 =?us-ascii?q?S4yDl0mSkzrqWDxCzO3/jidB0fN2FRQmltkE3sIYm0jtwAR0iobxYmlAW56k?=
 =?us-ascii?q?b62adboqd/L27ITEdMfij2KXxiU6SqurqDZc5P9I0nsSFNXOugZlCaT6b3ow?=
 =?us-ascii?q?EG3CP7A2te2Dc7eim2upX2mxx7h3mQLHJyrHrfZMFw2Q3f5NvaRf5Q0TsKXj?=
 =?us-ascii?q?R3hifPDFimI9ap5cmUl4vEsu2mVGKuTJxTfTPwzYOeriS75WtqDAa+n/C1ht?=
 =?us-ascii?q?3oDww63TXn2NltUCXCtAz8bZXz16SmLeJneVFlC0Tk68dhAI5+loowi48W2X?=
 =?us-ascii?q?UZnJma4GQIm3/pMdpHwaL+cGYNRTkTzt7X5wjlw01jI2mLx4L+TXWdwtdhZ8?=
 =?us-ascii?q?O7YmMO3iIy8dxKCLuO4LxDhyt1rUKyrRjNbvhlgjcd1fwu5WYeg+EUpAotyT?=
 =?us-ascii?q?6QArMMEklCOyzjiRCI48q5rKVNa2alaaKw21ZmndC9ELGCpRlRWHXjdZcjBy?=
 =?us-ascii?q?Nw7th/P0jK0H388Yzked/Qbc4NuR2QiRvPk+9VKJcpnPoQmSVnIX79vWEiy+?=
 =?us-ascii?q?Mjlxxu3I+1vI6bK2Vv4q25GQVVNjLyZ8MU9THtibhRktyK0ICoG5VrAi8LU4?=
 =?us-ascii?q?fwTfK0DDISsuzqOBqQHzIhsHebGKbQERWQ6UdnqXLPHIumN3CRJHkF09piQA?=
 =?us-ascii?q?ORK1BYgAARRD86hII2Fhi2xMz9d0d0/igR5kP5qhtQ1O1oLRf+UmbdpAercT?=
 =?us-ascii?q?o0UoaQIwdW7g5Y+0fZK9CR7uV2HytA5J2usBSNKnCHZwRPFWwJXk2EB1b+Pr?=
 =?us-ascii?q?ih/NXA6PaXCfajL/vUYLWOtexfW+6NxZKoz4Rm4jKMOduUM3l8AP00xFBDUW?=
 =?us-ascii?q?p6G8vHgTUPTTIYlybXY86cvhe89TV9rtqj//TzRALv+YyPBqNJMdVy4RC5n7?=
 =?us-ascii?q?yDN+6KiCliMzpYzZIMymLVx7gfxlEfkCBudz+xEbsesS7BVr7fmqhSD01TVy?=
 =?us-ascii?q?QmFsJS7KE7ljJEOs3ajN7znup6h+Q2CFADTlXimcCvaMoiJ2C7KUOBBUCXOb?=
 =?us-ascii?q?DALjrOlZLZe6S5HIZMgf1Uuhv4gjOSF0vuL3zXjDXyfwy+OuFLyieANVpRv5?=
 =?us-ascii?q?/rIUUlMnTqUN+zMk7zC9RwlzBjhORv134=3D?=
X-IPAS-Result: =?us-ascii?q?A2CpAABMMrxd/wHyM5BlGgEBAQEBAQEBAQMBAQEBEQEBA?=
 =?us-ascii?q?QICAQEBAYF9gXQsbFQBMiqEKI8MVAaBESWJY5FCCQEBAQEBAQEBAS0HAQIBA?=
 =?us-ascii?q?YFMgnQCg3skOBMCDgEBAQQBAQEBAQUDAQFshTcMgjspAYJtAQUjDwEFQRALG?=
 =?us-ascii?q?AICJgICVwYNBgIBAYJfPwGCUiUPshGBMokMgUIGgQ4ojBEYeIEHgREnDIJfP?=
 =?us-ascii?q?oJiBIE5BgEBgy6CXgStcoIugjOEXo4eBhuZZZZukzcigVgrCAIYCCEPgyhPE?=
 =?us-ascii?q?RSMDYVbJQMxAYEDAQGLJw4XghkBAQ?=
Received: from tarius.tycho.ncsc.mil ([144.51.242.1])
  by EMSM-GH1-UEA10.NCSC.MIL with ESMTP; 01 Nov 2019 13:28:18 +0000
Received: from moss-pluto.infosec.tycho.ncsc.mil (moss-pluto [192.168.25.131])
        by tarius.tycho.ncsc.mil (8.14.4/8.14.4) with ESMTP id xA1DSHtY019172;
        Fri, 1 Nov 2019 09:28:17 -0400
Subject: Re: [PATCH v23 12/24] x86/sgx: Linux Enclave Driver
From:   Stephen Smalley <sds@tycho.nsa.gov>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-sgx@vger.kernel.org, akpm@linux-foundation.org,
        dave.hansen@intel.com, sean.j.christopherson@intel.com,
        nhorman@redhat.com, npmccallum@redhat.com, serge.ayoun@intel.com,
        shay.katz-zamir@intel.com, haitao.huang@intel.com,
        andriy.shevchenko@linux.intel.com, tglx@linutronix.de,
        kai.svahn@intel.com, bp@alien8.de, josh@joshtriplett.org,
        luto@kernel.org, kai.huang@intel.com, rientjes@google.com,
        cedric.xing@intel.com, puiterwijk@redhat.com,
        linux-security-module@vger.kernel.org,
        Suresh Siddha <suresh.b.siddha@intel.com>
References: <20191028210324.12475-1-jarkko.sakkinen@linux.intel.com>
 <20191028210324.12475-13-jarkko.sakkinen@linux.intel.com>
 <173a196e-fa6b-23b8-c818-dfca6cdadcc6@tycho.nsa.gov>
 <20191031211721.GD10507@linux.intel.com>
 <f91d788c-b372-8e2f-7ffb-995f501b5d6b@tycho.nsa.gov>
Message-ID: <4bf866ae-adc8-7902-3714-b62e548d8584@tycho.nsa.gov>
Date:   Fri, 1 Nov 2019 09:28:17 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <f91d788c-b372-8e2f-7ffb-995f501b5d6b@tycho.nsa.gov>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On 11/1/19 9:16 AM, Stephen Smalley wrote:
> On 10/31/19 5:17 PM, Jarkko Sakkinen wrote:
>> On Wed, Oct 30, 2019 at 09:45:05AM -0400, Stephen Smalley wrote:
>>> On 10/28/19 5:03 PM, Jarkko Sakkinen wrote:
>>>> Intel Software Guard eXtensions (SGX) is a set of CPU instructions that
>>>> can be used by applications to set aside private regions of code and
>>>> data. The code outside the SGX hosted software entity is disallowed to
>>>> access the memory inside the enclave enforced by the CPU. We call these
>>>> entities as enclaves.
>>>>
>>>> This commit implements a driver that provides an ioctl API to construct
>>>> and run enclaves. Enclaves are constructed from pages residing in
>>>> reserved physical memory areas. The contents of these pages can only be
>>>> accessed when they are mapped as part of an enclave, by a hardware
>>>> thread running inside the enclave.
>>>>
>>>> The starting state of an enclave consists of a fixed measured set of
>>>> pages that are copied to the EPC during the construction process by
>>>> using ENCLS leaf functions and Software Enclave Control Structure 
>>>> (SECS)
>>>> that defines the enclave properties.
>>>>
>>>> Enclave are constructed by using ENCLS leaf functions ECREATE, EADD and
>>>> EINIT. ECREATE initializes SECS, EADD copies pages from system 
>>>> memory to
>>>> the EPC and EINIT check a given signed measurement and moves the 
>>>> enclave
>>>> into a state ready for execution.
>>>>
>>>> An initialized enclave can only be accessed through special Thread 
>>>> Control
>>>> Structure (TCS) pages by using ENCLU (ring-3 only) leaf EENTER.  
>>>> This leaf
>>>> function converts a thread into enclave mode and continues the 
>>>> execution in
>>>> the offset defined by the TCS provided to EENTER. An enclave is exited
>>>> through syscall, exception, interrupts or by explicitly calling another
>>>> ENCLU leaf EEXIT.
>>>>
>>>> The permissions, which enclave page is added will set the limit for 
>>>> maximum
>>>> permissions that can be set for mmap() and mprotect(). This will
>>>> effectively allow to build different security schemes between 
>>>> producers and
>>>> consumers of enclaves. Later on we can increase granularity with LSM 
>>>> hooks
>>>> for page addition (i.e. for producers) and mapping of the enclave 
>>>> (i.e. for
>>>> consumers)
>>>
>>> Where do things stand wrt to ensuring that SGX cannot be used to 
>>> introduce
>>> executable mappings that were never authorized by the LSM (or never 
>>> measured
>>> by IMA)?
>>
>> This was the latest discussion about that subject:
>>
>> https://lore.kernel.org/linux-sgx/CALCETrWDLX68Vi4=9Dicq9ATmJ5mv36bzrc02heNYaHaBeWumQ@mail.gmail.com/ 
>>
> 
> So, IIUC, that means that merging the driver will create a regression 
> with respect to LSM control over executable mappings that will only be 
> rectified at some future point in time if/when someone submits LSM hooks 
> or calls to existing hooks to restore such control.  That doesn't seem 
> like a good idea.  Why can't you include at least that basic level of 
> control now?  It is one thing to defer finer grained control or 
> SGX-specific access controls to the future - that I can understand.  But 
> introducing a regression in the existing controls is not really ok.

Unless you are arguing that the existing checks on mmap/mprotect of 
/dev/sgx/enclave are a coarse-grained approximation (effectively 
requiring WX to the file or execmem for any user of SGX).

