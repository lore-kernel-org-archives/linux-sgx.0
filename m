Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 847E0C433E0
	for <linux-sgx@archiver.kernel.org>; Fri, 12 Mar 2021 21:06:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 53B9764F2A
	for <linux-sgx@archiver.kernel.org>; Fri, 12 Mar 2021 21:06:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234950AbhCLVFd (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 12 Mar 2021 16:05:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234962AbhCLVFO (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Fri, 12 Mar 2021 16:05:14 -0500
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24AF8C061762
        for <linux-sgx@vger.kernel.org>; Fri, 12 Mar 2021 13:05:14 -0800 (PST)
Received: by mail-pg1-x529.google.com with SMTP id g4so16653497pgj.0
        for <linux-sgx@vger.kernel.org>; Fri, 12 Mar 2021 13:05:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=6Dit5vwBS0Tl56hF0sV6VbghcZIe1S41EYMzdih+yBg=;
        b=nEeSswegnhhkAibhJ1uTCz7k5obZ5nRpCoOdtmVAkMw2qaaCjJhhVDtmoL4tNpnCDw
         Y5LFSWSrhdqOAuH/HVKJ4dk5mN5Mx6FvXYQxPN2A7CDRD9SK5Oc4qZ5qKjf/y10yIm+U
         OSKK9/uMf/AV42XbKI7nsC/a4baXpBGqGB8GsManeYAWIrs59hulg3oAnNh9jUEjTB66
         vNO8UAvI9plmjN4fIXrVe6H2bUJUzRmL67aCRXe27F25eXLrkmwsdExayHAA4a9qeQo8
         Vtf8UudYTpY17b50gdeUC06E0XHFn37p5YCbAkpbpoA8ra/9ybWm42/JtkMCKoUrew5E
         yXcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=6Dit5vwBS0Tl56hF0sV6VbghcZIe1S41EYMzdih+yBg=;
        b=fib+L5HLOYz+nb13XKSO9NNBSRbUJfQcznlK0JifmpXt56c3N3FVVEuJGfz93mDaAF
         ITOJJJDX+1cVjc/oMSvftRMRH5pKIHl1C2WM7rJfRuznmBf6+Kr1zYwT7nbcJ3ZvSEAP
         85rjAQPgnHjimwSzffsGM6JfZ9QkMzGv2pGhWCU4Db8z7aDn1cIrVBZ3aAUMvz+2rBRf
         gU0Mxnc+/+B3B7IKhC9TIhjtFNgrg0TDUbXYEsU4sCWLf46gIqHvX8PALnRMfVXmOGbn
         T8FtOZfh8xIiHltsqJ9G0PtywBJnQOt19jjKHODdUaB3CK3Z2wt1ZtLx7bo5JDhl8Js3
         YAtQ==
X-Gm-Message-State: AOAM530Pn372lE088mwLkMaCDdeMfdwoMOWCqtJAWaIZp3Hs9kOql35Q
        4AcVmwpdHH7MPDhwu8tiKNwUwg==
X-Google-Smtp-Source: ABdhPJzmemUX7SbHrAbNu7g0mrdTwUprvem2ml8WOxUCNjRg9YPyfEYgNbttg2HkiAkobkQsrqU4rQ==
X-Received: by 2002:a63:f14e:: with SMTP id o14mr14118322pgk.260.1615583113422;
        Fri, 12 Mar 2021 13:05:13 -0800 (PST)
Received: from google.com ([2620:15c:f:10:e1a6:2eeb:4e45:756])
        by smtp.gmail.com with ESMTPSA id v18sm6632395pfn.117.2021.03.12.13.05.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Mar 2021 13:05:12 -0800 (PST)
Date:   Fri, 12 Mar 2021 13:05:06 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Kai Huang <kai.huang@intel.com>
Cc:     kvm@vger.kernel.org, x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org, jarkko@kernel.org, luto@kernel.org,
        dave.hansen@intel.com, rick.p.edgecombe@intel.com,
        haitao.huang@intel.com, pbonzini@redhat.com, bp@alien8.de,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Subject: Re: [PATCH v2 01/25] x86/cpufeatures: Make SGX_LC feature bit depend
 on SGX bit
Message-ID: <YEvXgpqvwH2O/5pE@google.com>
References: <cover.1615250634.git.kai.huang@intel.com>
 <eaf02a594f0fb27ab3f358a0effef5519f4824e8.1615250634.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <eaf02a594f0fb27ab3f358a0effef5519f4824e8.1615250634.git.kai.huang@intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Mar 09, 2021, Kai Huang wrote:
> Move SGX_LC feature bit to CPUID dependency table to make clearing all
> SGX feature bits easier. Also remove clear_sgx_caps() since it is just
> a wrapper of setup_clear_cpu_cap(X86_FEATURE_SGX) now.
> 
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Acked-by: Dave Hansen <dave.hansen@intel.com>
> Acked-by: Jarkko Sakkinen <jarkko@kernel.org>
> Signed-off-by: Kai Huang <kai.huang@intel.com>
> ---

Reviewed-by: Sean Christopherson <seanjc@google.com>
