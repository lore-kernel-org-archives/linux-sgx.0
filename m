Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4A1EC28D13
	for <linux-sgx@archiver.kernel.org>; Thu, 25 Aug 2022 15:49:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235762AbiHYPtq (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 25 Aug 2022 11:49:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235510AbiHYPtp (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Thu, 25 Aug 2022 11:49:45 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E5F0B7299
        for <linux-sgx@vger.kernel.org>; Thu, 25 Aug 2022 08:49:43 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id s31-20020a17090a2f2200b001faaf9d92easo5362833pjd.3
        for <linux-sgx@vger.kernel.org>; Thu, 25 Aug 2022 08:49:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=XnBcNRbuBOvQNrejHxj5gOQgFkqYtm3hqw7VV6S1TjM=;
        b=kbXKPxRB0MLEB91m/6PZh/suS+TQN85X/JCmkLxQGzBEMhG5pk3gX0daKdlWk4ZpzG
         pDvVMNXjPpDkLk75GEPwP3GhjhV8wXV5NKdQKVuNsdURpD+mSfjrv9wqil1rTCcmwuLZ
         PxkaflqQNNnHIK8Fsn4xpxj+pvDOv2gK5WkJvkdXeQFDXo7li5PTEbJSENicwIyxOW88
         zTcWN/m9IkgLWFqQ5zrTVTxdL37vlDqT14eItEVV5qQToKz6c2IyYjUrpBWN/MMdiweL
         kNsaRR1jKXZKn2KmH/u30v7z1zpyst4aXxUF6/2MZC8XqcDGx3siac0tzO4JFLRy++fj
         na6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=XnBcNRbuBOvQNrejHxj5gOQgFkqYtm3hqw7VV6S1TjM=;
        b=BMA46bh5orZJFP7KMKGw5jmGwcY2nVMq3Y/V/hT1WGlNgAS4eLjdMfV68FYqd+Bbt5
         OoOuqjUkJgX7SmmLTSCiTotSXRgRJTdwG1T456z3QZZXoUeQMmPUggNBT090de7xJleW
         cNBzTJaRxXUUTg/HYFhDWHJ90ODAsSu19cny8gsOitSgPVyCAhH9E7/+b5KoAAw9FOUQ
         LRy1awZ1a5DDctDzuOP6WMCB1bIIlKtD7XCDlzxEmEMSG9RaF3J2ZSWrFmZrptiOH59p
         lyEDQOt3DQeSWz6u0YPwiiAcvWTCy1Rcr4SMastGnezEiTfT4jNwEf5P4rHthF1hfGDh
         bF7w==
X-Gm-Message-State: ACgBeo303gtN+Imi7/oxzcZso2UzbCresufQ5m6tL38NPzW7KVPENxUx
        iJ3rvbREpl2a76KbeqVwDue2Kg==
X-Google-Smtp-Source: AA6agR7JCOLJ+n/2pdOTFgYwP1eo3mBpnb0G42ds19yiz204HmIBIeIk4KoejwCNvbrNeblvNkT8bw==
X-Received: by 2002:a17:902:7c94:b0:170:aed6:7e6c with SMTP id y20-20020a1709027c9400b00170aed67e6cmr4250792pll.10.1661442583026;
        Thu, 25 Aug 2022 08:49:43 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id g5-20020a170902d1c500b0016eea511f2dsm14602650plb.242.2022.08.25.08.49.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Aug 2022 08:49:42 -0700 (PDT)
Date:   Thu, 25 Aug 2022 15:49:38 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     Jarkko Sakkinen <jarkko@kernel.org>,
        Kai Huang <kai.huang@intel.com>, dave.hansen@linux.intel.com,
        linux-sgx@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, pbonzini@redhat.com,
        haitao.huang@linux.intel.com
Subject: Re: [PATCH v2] x86/sgx: Allow exposing EDECCSSA user leaf function
 to KVM guest
Message-ID: <YweaEl48I7pxKMm8@google.com>
References: <20220818023829.1250080-1-kai.huang@intel.com>
 <YwbrywL9S+XlPzaX@kernel.org>
 <YweS9QRqaOgH7pNW@google.com>
 <236e5130-ec29-e99d-a368-3323a5f6f741@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <236e5130-ec29-e99d-a368-3323a5f6f741@intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Aug 25, 2022, Dave Hansen wrote:
> On 8/25/22 08:19, Sean Christopherson wrote:
> >>> This patch, along with your patch to expose AEX-notify attribute bit to
> >>> guest, have been tested that both AEX-notify and EDECCSSA work in the VM.
> >>> Feel free to merge this patch.
> > Dave, any objection to taking this through the KVM tree?
> 
> This specific patch?  Or are you talking about the couple of AEX-notify
> patches in their entirety?

I was thinking just this specific patch, but I temporarily forgot there are more
patches in flight.  It would be a bit odd to have effectively half of the AEX-notify
enabling go through KVM.

So with shortlog/changelog tweaks,

Acked-by: Sean Christopherson <seanjc@google.com>
