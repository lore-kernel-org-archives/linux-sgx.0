Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CCF3C433DB
	for <linux-sgx@archiver.kernel.org>; Tue,  9 Feb 2021 16:51:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D106664EB8
	for <linux-sgx@archiver.kernel.org>; Tue,  9 Feb 2021 16:51:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232894AbhBIQvQ (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 9 Feb 2021 11:51:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233094AbhBIQtG (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Tue, 9 Feb 2021 11:49:06 -0500
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 110CEC06174A
        for <linux-sgx@vger.kernel.org>; Tue,  9 Feb 2021 08:48:26 -0800 (PST)
Received: by mail-pg1-x533.google.com with SMTP id b21so12806285pgk.7
        for <linux-sgx@vger.kernel.org>; Tue, 09 Feb 2021 08:48:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=EXWPNsJpzjeuuDLRADZAeXF66eXi4rpWz4gB0/VueD8=;
        b=UAo2z8RW2sUzhpxfvKVzs61wPj1iZPXoJoXRXzUDgCNcdBibf8MEcYu5Af0gCpHpvI
         TI/zD8rzqYDV5GrORkB4lba0AVUO8eoF8lzbwi3+H3JpmGeVdQ7+7gZKcuKhdm9oKHRy
         nPxbvjf2eg3/jD9FcEw25SyJVuYvsYuilMZIcQYMohc7srVeF1ZINP0pd6UFIRm2BMhE
         iNJlnUPiS216Sjb1ecvqw/uTk8XwhvHK+3ddOcfgi9wGfZwV7lCeXutPG8oTqTYdPmLl
         zRMnLKLxHq2+yQha5wMKHOJm58SS/U1XHRQDjeXCMcjvbGvqmLzBlAF0wcdI2HclUa0Z
         ZC7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=EXWPNsJpzjeuuDLRADZAeXF66eXi4rpWz4gB0/VueD8=;
        b=JBmJOXe7ONIGrlfa3vjLs/I4TkFwJAEnzUIeJV2erKoIRYSingCPkMYq35OhGQGkiV
         pTKItswsQmKI9WzFf58SNOHRwBVJLZvosxWTKJ8AgMijMsBOFGklGWe9rMz8VdwpTQb8
         PFwCDUnYt+KVIg5twktBU2s+SNQJ7zmy5joZEIXS4pnU4Ab7aeAQ9daORqtN8Oz09YMr
         x5tL18fO2HAV0llC7lskdZ7IPPChxmMcOiTzvSowgMGMnZIM42w4e4z3XJlqVcx/6Ml+
         biBYtdpBhHxsi6cmwpPzPR9aWrs7KKD9wJxlk/dHJu01gEzpntBHoDHS8WFD8FKFN+dT
         3UZg==
X-Gm-Message-State: AOAM530RybuCXVDGWNRbSENnb/p3FKQ0P1+4B73bKP2aJ3PlE/E+/DIp
        mIkaaoWnHX6lf9JWztxGfqwBl7qYPuR4xQ==
X-Google-Smtp-Source: ABdhPJy1L6WfOh2elLxCyP+ILOVp79ZszE5ugkqMwsqdbbfiyOhx7aL2+M9IToFYpPtaMH2vHQQd+w==
X-Received: by 2002:a63:f405:: with SMTP id g5mr22946290pgi.276.1612889305403;
        Tue, 09 Feb 2021 08:48:25 -0800 (PST)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id t6sm23139205pfe.177.2021.02.09.08.48.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Feb 2021 08:48:24 -0800 (PST)
Date:   Tue, 9 Feb 2021 16:48:21 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     Kai Huang <kai.huang@intel.com>, linux-sgx@vger.kernel.org,
        kvm@vger.kernel.org, x86@kernel.org, jarkko@kernel.org,
        luto@kernel.org, rick.p.edgecombe@intel.com,
        haitao.huang@intel.com, pbonzini@redhat.com, bp@alien8.de,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Subject: Re: [RFC PATCH v4 04/26] x86/sgx: Add SGX_CHILD_PRESENT hardware
 error code
Message-ID: <YCK81Zcz++PfGPnw@google.com>
References: <cover.1612777752.git.kai.huang@intel.com>
 <3c1edb38e95843eb9bf3fcbbec6cf9bdd9b3e7b1.1612777752.git.kai.huang@intel.com>
 <b9e8a9a0-6a53-6523-4ea8-347c67e7ba86@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b9e8a9a0-6a53-6523-4ea8-347c67e7ba86@intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Feb 09, 2021, Dave Hansen wrote:
> On 2/8/21 2:54 AM, Kai Huang wrote:
> ...
> > Add SGX_CHILD_PRESENT for use by SGX virtualization to assert EREMOVE
> > failures are expected, but only due to SGX_CHILD_PRESENT.
> 
> This paragraph broke my brain when I read it.  How about:
> 
> 	Add a definition of SGX_CHILD_PRESENT.  It will be used
> 	exclusively by the SGX virtualization driver to suppress EREMOVE
> 	warnings.

Maybe worth clarifying that the driver isn't suppressing warnings willy-nilly?
And the error code isn't about suppressing warnings, it's about identifying the
expected EREMOVE failure scenario.  The patch that creates the separate helper
for doing EREMOVE without the WARN is what provides the suppression mechanism.

Something like this?

  Add a definition of SGX_CHILD_PRESENT.  It will be used exclusively by
  the SGX virtualization driver to handle recoverable EREMOVE errors when
  saniziting EPC pages after they are reclaimed from a guest.
