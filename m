Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8439DC433DB
	for <linux-sgx@archiver.kernel.org>; Fri, 12 Mar 2021 21:34:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4475764F8E
	for <linux-sgx@archiver.kernel.org>; Fri, 12 Mar 2021 21:34:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235278AbhCLVd4 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 12 Mar 2021 16:33:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235274AbhCLVdk (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Fri, 12 Mar 2021 16:33:40 -0500
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3007C061761
        for <linux-sgx@vger.kernel.org>; Fri, 12 Mar 2021 13:33:39 -0800 (PST)
Received: by mail-pg1-x533.google.com with SMTP id v14so9766705pgq.2
        for <linux-sgx@vger.kernel.org>; Fri, 12 Mar 2021 13:33:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=iVsxRcsawWsgdZYrcTYOb1n/2Sbbp73pya7fmqOzbMM=;
        b=iU0N0qMeYphwKiEy/0gaspa6VWKm+Nt69kIn87RoNKxVXvrAx5xTe9v5AzEAN28HA7
         YtKRHO05kwSsCPWGpTpqIWE+yljx5wsWZMMfePpFUKqDFK1aK35s/y3dWNP7OZ7ZCZVR
         0zMS3dzjgF/LijZi2YGejfpyGDSV74yVL59mb7BVQ8AD/EzLTxdkB1pU32QGNoNJ1t28
         HheevnlBsUSuT/xl8BNmCnFrt1FBOsBZzfa7c69ql6kTimL4Dd1eU6mw03rA42jgrqts
         Rk+GNZU77eHk7SlGMBw8oaHOlrroqEqRpGRkXTCZATJVsi3Jjcik4oEbnpRf0SWORfUA
         LoEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=iVsxRcsawWsgdZYrcTYOb1n/2Sbbp73pya7fmqOzbMM=;
        b=R0OruXi7nE64id8KpQgrxmrOyMZenoUFVjoKgKmFnFhC8lDRrcSABQxxyFugsDEXX9
         +Dc9Z95f1ZTLIyOKNISuhlhbN2vXQjUtDsug4pagpTIr0RUDHMgjSxd5uHjqIbyRi0m5
         eeIXpznHbEovsXohicsYN7/v0PbYqUHwL7D4+n7zP1vMSueeeoumKfqpA0yT/e1eVHZz
         yJOa4E7x/CsO3KPCt7MWsrRuVxsCCJd81yqFSV4CVsmMMFwHimul4fDlAM8CTug7pD1g
         KAemQmo9j65BpY7x1wiEE1i7daKJgaarg9IwyAdtJ0RJ/o4AUySWgvsyh4VOB6LjInMf
         Anhg==
X-Gm-Message-State: AOAM530vRsC9hz4MhEIn+udkg/r2/YJb/gZkHLp+uIWMpGe+QgwlHHET
        dC+IeRjp5k+yzP9UAD5qQjv1tw==
X-Google-Smtp-Source: ABdhPJyzFmLGS3OHDbNmbZP3xGaBaD+KZkN2wLIU/7KbnCgdx1a9fR5Dif0M2wDntXghS47+usszog==
X-Received: by 2002:a63:74d:: with SMTP id 74mr13471770pgh.316.1615584819001;
        Fri, 12 Mar 2021 13:33:39 -0800 (PST)
Received: from google.com ([2620:15c:f:10:e1a6:2eeb:4e45:756])
        by smtp.gmail.com with ESMTPSA id i14sm3141527pjh.17.2021.03.12.13.33.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Mar 2021 13:33:38 -0800 (PST)
Date:   Fri, 12 Mar 2021 13:33:31 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Kai Huang <kai.huang@intel.com>
Cc:     kvm@vger.kernel.org, x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org, jarkko@kernel.org, luto@kernel.org,
        dave.hansen@intel.com, rick.p.edgecombe@intel.com,
        haitao.huang@intel.com, pbonzini@redhat.com, bp@alien8.de,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        jethro@fortanix.com, b.thiel@posteo.de
Subject: Re: [PATCH v2 06/25] x86/cpu/intel: Allow SGX virtualization without
 Launch Control support
Message-ID: <YEveK42VVla8ibkl@google.com>
References: <cover.1615250634.git.kai.huang@intel.com>
 <f6d21cea6cd3b477a0e12c785feb0b6a2cfdde58.1615250634.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f6d21cea6cd3b477a0e12c785feb0b6a2cfdde58.1615250634.git.kai.huang@intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Mar 09, 2021, Kai Huang wrote:
> +	if (cpu_has(c, X86_FEATURE_SGX) && IS_ENABLED(CONFIG_X86_SGX)) {
> +		/*
> +		 * Separate out SGX driver enabling from KVM.  This allows KVM
> +		 * guests to use SGX even if the kernel SGX driver refuses to
> +		 * use it.  This happens if flexible Faunch Control is not

/Faunch/Launch

Clever handling of the multitude of combinations!
