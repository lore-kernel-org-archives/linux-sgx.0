Return-Path: <SRS0=Z+an=6G=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0D75C55185
	for <linux-sgx@archiver.kernel.org>; Wed, 22 Apr 2020 16:49:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AE9AA2098B
	for <linux-sgx@archiver.kernel.org>; Wed, 22 Apr 2020 16:49:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dgA0xrpr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726655AbgDVQtP (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 22 Apr 2020 12:49:15 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:22990 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726421AbgDVQtL (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Wed, 22 Apr 2020 12:49:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587574149;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SYqq55jpNG38qRRIFw7acQIWp2Eu+K77BU0ArhjzWnY=;
        b=dgA0xrprXy3WlLWQtr89X/Ot7Byq6xLsgK+8hEqawxa8u7A3bzjxPhX6+W+kUfYzV09LF7
        w13QOBrPo8pYlcU/8bCd9uB5OiDHeWktgNgIlVwgyUncvMz5xejY0axd98ruDfGCNn+x/j
        YKpD/TYB0RbqnNBPwjy/RV4zkCemX4E=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-454-PEDii1UtMJezAra3_oiWrw-1; Wed, 22 Apr 2020 12:49:04 -0400
X-MC-Unique: PEDii1UtMJezAra3_oiWrw-1
Received: by mail-qv1-f70.google.com with SMTP id v2so2865634qvy.1
        for <linux-sgx@vger.kernel.org>; Wed, 22 Apr 2020 09:49:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=SYqq55jpNG38qRRIFw7acQIWp2Eu+K77BU0ArhjzWnY=;
        b=euIt1wRABZSkddQJmQC1f9UOdq0X2VFp+Es/V8gNQZ8nHywq6Su8yl04TfWZmLgpZf
         iaZedWkl4szSCAee6OurVeicWDYr9MI13OEPUckMxJeTa6rrg84fjS2A7bJXaXPGTzmm
         dm2pCnNwXCE4wJCILBuNWW4pgLdvVeSlEylpZttODpYBFmm77PjpQPwRtBX7h7Okbu/5
         Uvxmf8jItsP0b5B0PZvVrC7sWYUvJDRdbOIbwsMsNrQlRrKL+TW9d26LLxQGj4ruNmQV
         fg5jSaCcxyaEfSVSojKQh9QmX2ZHnA2vVrQmLZrgRH+fxTV3/lImKBrtWxs5OMgiZMVj
         E/Tw==
X-Gm-Message-State: AGi0PuY1MDXku7JLJu4hMI7AXrOtxui0at41gLickc98OFbNeBiI64SF
        tT5Dc2L8SFk5qHzoi0Uduqi/lgStwxt9ZxhOEJU5l8pLGZ/Ls03r/vTMXcwX/gAe/jrSd+lpLEr
        6fxJ3NedDK9kW9A1mT8//
X-Received: by 2002:ac8:550c:: with SMTP id j12mr27718225qtq.22.1587574143661;
        Wed, 22 Apr 2020 09:49:03 -0700 (PDT)
X-Google-Smtp-Source: APiQypLykwvtylHrDcgIvH0Y7W9cU1MCrXPi+7bW8iApdAIU/TbNCwQJxaG0noJLhR9KpUestzs+pg==
X-Received: by 2002:ac8:550c:: with SMTP id j12mr27718197qtq.22.1587574143382;
        Wed, 22 Apr 2020 09:49:03 -0700 (PDT)
Received: from [192.168.0.172] (c-71-63-171-240.hsd1.or.comcast.net. [71.63.171.240])
        by smtp.gmail.com with ESMTPSA id c69sm4244840qkg.104.2020.04.22.09.49.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Apr 2020 09:49:02 -0700 (PDT)
Subject: Re: [PATCH v29 00/20] Intel SGX foundations
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-sgx@vger.kernel.org
Cc:     akpm@linux-foundation.org, dave.hansen@intel.com,
        sean.j.christopherson@intel.com, nhorman@redhat.com,
        npmccallum@redhat.com, haitao.huang@intel.com,
        andriy.shevchenko@linux.intel.com, tglx@linutronix.de,
        kai.svahn@intel.com, bp@alien8.de, josh@joshtriplett.org,
        luto@kernel.org, kai.huang@intel.com, rientjes@google.com,
        cedric.xing@intel.com, puiterwijk@redhat.com
References: <20200421215316.56503-1-jarkko.sakkinen@linux.intel.com>
From:   Connor Kuehl <ckuehl@redhat.com>
Message-ID: <72e8fd3e-5d35-669c-3186-43754333fceb@redhat.com>
Date:   Wed, 22 Apr 2020 09:48:58 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200421215316.56503-1-jarkko.sakkinen@linux.intel.com>
Content-Language: en-US
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On 4/21/20 2:52 PM, Jarkko Sakkinen wrote:
> v29:
> * The selftest has been moved to selftests/sgx. Because SGX is an execution
>    environment of its own, it really isn't a great fit with more "standard"
>    x86 tests.
> 
>    The RSA key is now generated on fly and the whole signing process has
>    been made as part of the enclave loader instead of signing the enclave
>    during the compilation time.
> 
>    Finally, the enclave loader loads now the test enclave directly from its
>    ELF file, which means that ELF file does not need to be coverted as raw
>    binary during the build process.
> * Version the mm_list instead of using on synchronize_mm() when adding new
>    entries. We hold the write lock for the mm_struct, and dup_mm() can thus
>    deadlock with the page reclaimer, which could hold the lock for the old
>    mm_struct.
> * Disallow mmap(PROT_NONE) from /dev/sgx. Any mapping (e.g. anonymous) can
>    be used to reserve the address range. Now /dev/sgx supports only opaque
>    mappings to the (initialized) enclave data.
> * Make the vDSO callable directly from C by preserving RBX and taking leaf
>    from RCX.

Hi all,

I've been producing Fedora 32 kernel builds with the SGX patches applied 
for a few of weeks and I've just produced a build with this latest 
revision[1]. We've been using these kernels to enable SGX for some of 
our development/test machines.

We wanted to offer them here in the hopes that others might find them 
useful for testing the SGX patchsets on their own machines to send 
feedback to this list. Please note that these are *not* meant to replace 
your distro kernel and these are for testing purposes only.

I'll continue to upload builds to a Fedora Copr[2] as long as the 
patches continue to apply cleanly to the Fedora kernels.

Best,

Connor

[1] 
https://download.copr.fedorainfracloud.org/results/npmccallum/enarx/fedora-32-x86_64/01344404-kernel/

[2] https://copr.fedorainfracloud.org/coprs/npmccallum/enarx/

[3] This is the packaging branch that I work from and rebase on top of 
the f32 kernels: 
https://github.com/connorkuehl/fedora-kernel-enarx-pkg/commits/f32-enarx

