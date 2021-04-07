Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FBF2C433B4
	for <linux-sgx@archiver.kernel.org>; Wed,  7 Apr 2021 22:17:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D2D6C61246
	for <linux-sgx@archiver.kernel.org>; Wed,  7 Apr 2021 22:17:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229510AbhDGWRQ (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 7 Apr 2021 18:17:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229488AbhDGWRP (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Wed, 7 Apr 2021 18:17:15 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B229C061760
        for <linux-sgx@vger.kernel.org>; Wed,  7 Apr 2021 15:17:04 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id t140so14069225pgb.13
        for <linux-sgx@vger.kernel.org>; Wed, 07 Apr 2021 15:17:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=X9ugYAwXT/ureXX1GFDh8KaDzFpw87RFikpzRN4GEwk=;
        b=cZuDsM0q6rhLG2g/SJJr+U5euIn9viBs/aJrzfiRA3zNllyBdrBv16d+LgOEK7foET
         QCJTaRDolYGWgTNAGHNkJPdWVceGYLXP0P0bj6yNVqJvn5U/uKlXw50KoG7fNljYIAQT
         KwR/z1nZ0JVPvP8oQthtfF3Ky2iZbugdwZPpS3pgCgrYrbdwUzJdbozo1e45tvqzgNmF
         oH7ORLVwxP2VPPaI5hHxjzb0Yzg+pFHn/dMtDnm6P9C77NHwmOrFkovTYEFl21U7yaaa
         6YhJkcA37vyl7uZnMwqQzJ4XcF89j4tXfk2Qw5SYjuOjhx6HDsXrgAzK73p9ZnRdARms
         8Rdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=X9ugYAwXT/ureXX1GFDh8KaDzFpw87RFikpzRN4GEwk=;
        b=RFnZ9CiSwx/2+01FwohhwgCjBjdXATvqRewyIkgTOYwBVN4vRccz1Rd4MHcTGdBDzc
         4HVt/5B7zE5aK1gNUPbfVq/jMDRPhtjgUtdCtTsOSFQT7CWV3oHh1RmXyi/bk2nLxtUV
         c2ZI8f8JeHqNcJKunlKR4CRZAW9SQDAJxSiHOVCYRYCChPqlPtWr3Ncb7IB0+mmyBvG4
         RQNCwN8+oFWRPBgYXTY05ZVINzP3sHg3zbxQJzKuMkKfC2Uw8casoExj6BdD748lVzB0
         3Y+jHkchwO8KPP/IRlFqrerPFFZTlbD9jz3e1oIB2Bl0amKMKQrMgHmdz30k/Vm77aSV
         lh9g==
X-Gm-Message-State: AOAM530DKUqWODKJVCU2ZL+KMq0WDEARoX9WvNxnDyTLj4MdF39HwSon
        7H6m4QF9ql8eQw799MqVJuEdZ0M/YDVIKA==
X-Google-Smtp-Source: ABdhPJzasV5McGx1ICJVbH129PTfPj5PdK2RyMf60yHN7Eh7ZRyxuXX27Fgc6pjFmpL6y47wYURtRw==
X-Received: by 2002:a62:7ccd:0:b029:1fb:2316:b93e with SMTP id x196-20020a627ccd0000b02901fb2316b93emr4694912pfc.34.1617833823931;
        Wed, 07 Apr 2021 15:17:03 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id n73sm23434625pfd.196.2021.04.07.15.17.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Apr 2021 15:17:03 -0700 (PDT)
Date:   Wed, 7 Apr 2021 22:16:59 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Kai Huang <kai.huang@intel.com>
Cc:     kvm@vger.kernel.org, linux-sgx@vger.kernel.org,
        pbonzini@redhat.com, bp@alien8.de, jarkko@kernel.org,
        dave.hansen@intel.com, luto@kernel.org, rick.p.edgecombe@intel.com,
        haitao.huang@intel.com
Subject: Re: [PATCH v4 06/11] KVM: VMX: Frame in ENCLS handler for SGX
 virtualization
Message-ID: <YG4vWwwhr01vZGp6@google.com>
References: <cover.1617825858.git.kai.huang@intel.com>
 <4be4b49f63a6c66911683d0f093ca5ef0d3996d5.1617825858.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4be4b49f63a6c66911683d0f093ca5ef0d3996d5.1617825858.git.kai.huang@intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Apr 08, 2021, Kai Huang wrote:
> +int handle_encls(struct kvm_vcpu *vcpu)
> +{
> +	u32 leaf = (u32)vcpu->arch.regs[VCPU_REGS_RAX];

Please use kvm_rax_read(), I've been trying to discourage direct access to the
array.  Which is ironic because I'm 100% certain I'm to blame for this. :-)

> +
> +	if (!encls_leaf_enabled_in_guest(vcpu, leaf)) {
> +		kvm_queue_exception(vcpu, UD_VECTOR);
> +	} else if (!sgx_enabled_in_guest_bios(vcpu)) {
> +		kvm_inject_gp(vcpu, 0);
> +	} else {
> +		WARN(1, "KVM: unexpected exit on ENCLS[%u]", leaf);
> +		vcpu->run->exit_reason = KVM_EXIT_UNKNOWN;
> +		vcpu->run->hw.hardware_exit_reason = EXIT_REASON_ENCLS;
> +		return 0;
> +	}
> +	return 1;
> +}
