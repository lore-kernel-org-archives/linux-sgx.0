Return-Path: <SRS0=o5ed=5U=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19CCDC2BA16
	for <linux-sgx@archiver.kernel.org>; Sat,  4 Apr 2020 07:28:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C93C120709
	for <linux-sgx@archiver.kernel.org>; Sat,  4 Apr 2020 07:27:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UTXqj54Z"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725868AbgDDH17 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sat, 4 Apr 2020 03:27:59 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:41845 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725837AbgDDH17 (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Sat, 4 Apr 2020 03:27:59 -0400
Received: by mail-lf1-f67.google.com with SMTP id z23so7691379lfh.8
        for <linux-sgx@vger.kernel.org>; Sat, 04 Apr 2020 00:27:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=1kIzIO5U+aFb/qE9B3vfgXisNSbO7XeDrI2rUd608FI=;
        b=UTXqj54ZagOnk9N6xx7O8M6AmlAE29rcCMVKM9ax7XQBmcCHwRyf1iMcUWBN+Dj8pj
         p0ufTanHgCreLkR9zrLf69FHyf69nBTXnh/ZHo5gUENcyRqzj3HFbziSFi44omh0q3ay
         WAIcD+1D1MAJ8zdmJFnu9I0+oYLHrHEMjvkUjDZx+3WXdNFrmdqYB2fyCVTKKJAmvApb
         9YxXXl1SH0gRQskocMVWNjoYlHNlWdQ6GGsIIbrTA0TOYtbgLAXZ3BD+AW1RXmoZ364k
         OwaJieRxtmTdkBohH2W4wHFXS/4d3fRzvICybiV2V+XS66lh4F0Ih9bUhPijjn2mkZIc
         F1Cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1kIzIO5U+aFb/qE9B3vfgXisNSbO7XeDrI2rUd608FI=;
        b=difGsLtK76YRTIaftmGB+r1yUy2V0150akHmnM6Xi3xRlfoWrFP8I6+0Rr+32Z92GB
         rc4XgJO/kTywUn2dRJlpfcCKIk7OXqTyka8MeA/Ts0/Jzz0EdZjpImmAEWO+I4oyIOqN
         IJjgtQxcQeqxQiwPyu00jlt+nAXP3iXEi/2AD2Drw0SvhmA5EVcKLPzM3JuIUBfRVopx
         Yv0aqv5r9uc6Taj7pTVtNnjp+qOmag039Wa6OJ7doWh1nPg4LnJBxq5BZjAPj85X10BP
         iMfXSCvjOt/ckJWkmT+wwwHMc0ApgY8+yGD+5LBh2ULq28AldYLW5DRRhOKJKliqCB0g
         LXrg==
X-Gm-Message-State: AGi0PuZGUV6gRP0ibwpqMC0SBDDJ2R2c/OBDnrNrtzFe1aJtv73+m9/6
        1tHKTQh/QzxA0BsBFzatcKc=
X-Google-Smtp-Source: APiQypIMVpbDnSpSy9oiPSWaXXb1iyKRrsLm80qj5HZz3OC8j5zfScyS87QyaozyWeSGek9J63TyMg==
X-Received: by 2002:ac2:42d9:: with SMTP id n25mr7471864lfl.97.1585985276040;
        Sat, 04 Apr 2020 00:27:56 -0700 (PDT)
Received: from [192.168.1.38] (88-114-211-119.elisa-laajakaista.fi. [88.114.211.119])
        by smtp.gmail.com with ESMTPSA id v22sm6148202ljc.79.2020.04.04.00.27.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 04 Apr 2020 00:27:55 -0700 (PDT)
Subject: Re: [PATCH 2/4] x86/sgx: Put enclaves into anonymous files
To:     Jethro Beekman <jethro@fortanix.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     Casey Schaufler <casey@schaufler-ca.com>,
        Andy Lutomirski <luto@kernel.org>, casey.schaufler@intel.com,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        linux-sgx@vger.kernel.org, "Svahn, Kai" <kai.svahn@intel.com>,
        "Schlobohm, Bruce" <bruce.schlobohm@intel.com>,
        Stephen Smalley <sds@tycho.nsa.gov>,
        Haitao Huang <haitao.huang@linux.intel.com>,
        ben@decadent.org.uk
References: <20200403220848.GA7588@linux.intel.com>
 <F117745A-E01B-499E-B9E4-201C1C08258D@amacapital.net>
 <454e7252-8827-510d-65f0-f2ca60208e27@fortanix.com>
From:   Topi Miettinen <toiwoton@gmail.com>
Message-ID: <ea7471ff-146a-73af-903d-34552614b302@gmail.com>
Date:   Sat, 4 Apr 2020 10:27:53 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <454e7252-8827-510d-65f0-f2ca60208e27@fortanix.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On 4.4.2020 8.46, Jethro Beekman wrote:
> This appears to originate in Debian
> 
> Rationale: https://salsa.debian.org/kernel-team/initramfs-tools/-/merge_requests/9
> 
> Interestingly, they claim mmap(/dev/zero) is special-cased? Can we do the same for SGX?
> 
> Some allowances were made in https://salsa.debian.org/kernel-team/initramfs-tools/-/commit/d6c6eeca3540d18f5bce95b5ffcb1823ab3050ea
> 
> Including those people in this conversation.
> 
> Ben, Towi: for context, see https://lore.kernel.org/linux-sgx/20200319142434.GA11305@linux.intel.com/T/ and https://lore.kernel.org/linux-sgx/20200401084511.GE17325@linux.intel.com/T/
> 
> --
> Jethro Beekman | Fortanix
> 
> On 2020-04-04 05:54, Andy Lutomirski wrote:
>>
>>
>>> On Apr 3, 2020, at 3:08 PM, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com> wrote:
>>>
>>> ﻿On Fri, Apr 03, 2020 at 08:50:08AM -0700, Casey Schaufler wrote:
>>>>> How does smackfs interact with namespaces?
>>>>
>>>> Smack attributes are global. Aside from privilege issues, namespaces
>>>> ignore and are ignored by Smack.
>>>
>>> Okay.
>>>
>>> For SGX, I foresee things as:
>>>
>>> 1. Existing files are global.
>>> 2. If a policy of any kind is ever added it needs to be *per container*.
>>>    I'm not sure whether PID or user namespace is the right choice here,
>>>    but does not matter right now as the feature is not in the queue.
>>>
>>> To summarize:
>>>
>>> 1. We have a heterogeneous set of files (i.e. 'enclave' and 'provision'
>>>    are not "different sames").
>>> 2. The files probably will have heterogeneous visibility requirements.
>>>
>>> I think based on these premises own file system would be a more decent
>>> choice than populating /dev. Beside, SGX hasn't been a driver for a
>>> while.
>>>
>>> Andy, what do you think of this?
>>
>> Probably okay.  There are two semantic questions you’ll have to address, though:
>>
>> - What happens if you mount sgxfs twice?  Do you get two copies that can diverge from each other, or do you get two views of the same thing?
>>
>> - Can it be instantiated from outside the root initns?
>>
>> It’s certainly conceptually simpler to stick with device nodes. Why exactly is Ubuntu noexecing /dev?
>>
>>>
>>> /Jarkko
> 

My goal is to block executing binaries directly from /dev and using the 
file descriptors from device files to avoid EXECMEM, without relying on 
MACs. If the SGX device can be used to make new executable mappings, it 
should honor noexec for /dev. Then initramfs should make a similar 
exception as with v86d and grant exec to /dev. I think sgxfs should also 
honor noexec but it probably does not make sense to mount it so.

With an ioctl to SGX device the caller can change previously writable 
memory to executable. It should be able to trigger PROCESS__EXECMEM 
check for SELinux, so perhaps LSM hook for mprotect should be called:
https://github.com/intel/linux-sgx-driver/blob/95eaa6f6693cd86c35e10a22b4f8e483373c987c/sgx_ioctl.c#L254

Also SELinux reference policy doesn't know yet about SGX. Can the SGX 
enclave access physical memory, kernel memory or bypass MMU somehow even 
for the thread? If it can bypass SELinux protections, access should be 
conditional to boolean allow_raw_memory_access.

-Topi
