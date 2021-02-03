Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBD3BC433E0
	for <linux-sgx@archiver.kernel.org>; Wed,  3 Feb 2021 23:02:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9962764E3D
	for <linux-sgx@archiver.kernel.org>; Wed,  3 Feb 2021 23:02:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233189AbhBCXBx (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 3 Feb 2021 18:01:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233480AbhBCXAf (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Wed, 3 Feb 2021 18:00:35 -0500
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3ED3C06178A
        for <linux-sgx@vger.kernel.org>; Wed,  3 Feb 2021 14:59:54 -0800 (PST)
Received: by mail-pf1-x42c.google.com with SMTP id b145so819481pfb.4
        for <linux-sgx@vger.kernel.org>; Wed, 03 Feb 2021 14:59:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Rid2fv6/wPAkXA4JAaPrJU7q0PnP27jO5G7adKV5pwY=;
        b=rqhrbcE7QrxyuVlFMRJstg/BmhxqU0a3s/b7xiTFGZ8NZW2+spqcEyAEvCmyDhRXI4
         B02Z+taYIVV3zFU3TgSS+/R3Tx+EZoOkH43OyWDEDzSYmuLTAiZnFXse5iUdo8OWyvr2
         y1fCFireVzRw5KMwf2c30FFzeeeiwOh//Cdb17RW88wLmfMijqq1vi3BzfiIxwBbcAVP
         1WBrzE3oCI4c4fi6LCxyh5MHImhJUdwf9JjokjIyUqP8iimUdCUr/dM22n8F7r3rDtor
         KWY3JYPnBmrY1w8aQpOzcjkS2KTHGMAl7T8gDVkOIEyrNaGy3jpZ17pSEuOduBXITFcz
         r/hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Rid2fv6/wPAkXA4JAaPrJU7q0PnP27jO5G7adKV5pwY=;
        b=UsAdM5QiVUXidhTVzUTfLqeP2i2BafiRuU8/dcM0WJ8fcGFI6K7yk0//dAJXO2vFjo
         ar9kGSj/esagcpv3xX9btwtCF3zFrr1+fLaiiLES0jR+/CdIXcCXXs12O+s9gy4O7h7E
         4lFILzlueLpUTxRomwr6ryml7jV+iaE9N+AME7Ylp4yDzsOHBMlhBfV+YqFbdzTYhzKq
         mnqJwrZDfo9bynQ+MDnMKMXwZKuiv+pSvKX8PblgmIVotlIWihu/K1OJQ1UYaFNAu2ZJ
         fBcYbKyG1VwGE8ubp/+3PC4vW017ccwffKIaF96nAN8ty7+rQT0FtFTVjBYe9sfcIXpa
         fCJA==
X-Gm-Message-State: AOAM5329Kq+QHR3G7cTPhCVQLuHV0LcyAq9xIb/4uI2fEo6sUv/juiVh
        l6nF9VpWIP3mrOhNESykp0htYFekYQEnww==
X-Google-Smtp-Source: ABdhPJy3RpDJpEd7+BN+DQZb4H/vc+DzYByaW1Hs7bQAJ5AeQyZ9ZNWwDb+5ywpFbB8fG8I7yFLiCA==
X-Received: by 2002:aa7:9637:0:b029:1c4:db58:97fc with SMTP id r23-20020aa796370000b02901c4db5897fcmr5160778pfg.81.1612393194314;
        Wed, 03 Feb 2021 14:59:54 -0800 (PST)
Received: from google.com ([2620:15c:f:10:a9a0:e924:d161:b6cb])
        by smtp.gmail.com with ESMTPSA id 17sm3455995pfv.13.2021.02.03.14.59.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Feb 2021 14:59:53 -0800 (PST)
Date:   Wed, 3 Feb 2021 14:59:47 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Jarkko Sakkinen <jarkko@kernel.org>
Cc:     Kai Huang <kai.huang@intel.com>, linux-sgx@vger.kernel.org,
        kvm@vger.kernel.org, x86@kernel.org, luto@kernel.org,
        dave.hansen@intel.com, haitao.huang@intel.com, pbonzini@redhat.com,
        bp@alien8.de, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Subject: Re: [RFC PATCH v3 08/27] x86/sgx: Initialize virtual EPC driver even
 when SGX driver is disabled
Message-ID: <YBsq45IDDX9PPc7s@google.com>
References: <cover.1611634586.git.kai.huang@intel.com>
 <5076ed2c486ac33bfd87dc0e17047a1673692b53.1611634586.git.kai.huang@intel.com>
 <YBVxF2kAl7VzeRPS@kernel.org>
 <20210201184040.646ea9923c2119c205b3378d@intel.com>
 <YBmMrqxlTxClg9Eb@kernel.org>
 <YBmX/wFFshokDqWM@google.com>
 <YBndRM9m0XHYwsPP@kernel.org>
 <20210203134906.78b5265502c65f13bacc5e68@intel.com>
 <YBsdeco/t8sa7ecV@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YBsdeco/t8sa7ecV@kernel.org>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Feb 04, 2021, Jarkko Sakkinen wrote:
> On Wed, Feb 03, 2021 at 01:49:06PM +1300, Kai Huang wrote:
> > What working *incorrectly* thing is related to SGX virtualization? The things
> > SGX virtualization requires (basically just raw EPC allocation) are all in
> > sgx/main.c. 
> 
> States:
> 
> A. SGX driver is unsupported.
> B. SGX driver is supported and initialized correctly.
> C. SGX driver is supported and failed to initialize.
> 
> I just thought that KVM should support SGX when we are either in states A
> or B.  Even the short summary implies this. It is expected that SGX driver
> initializes correctly if it is supported in the first place. If it doesn't,
> something is probaly seriously wrong. That is something we don't expect in
> a legit system behavior.

It's legit behavior, and something we (you?) explicitly want to support.  See
patch 05, x86/cpu/intel: Allow SGX virtualization without Launch Control support.
