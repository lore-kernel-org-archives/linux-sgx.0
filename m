Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A28ACC63777
	for <linux-sgx@archiver.kernel.org>; Tue, 17 Nov 2020 18:22:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3A52622447
	for <linux-sgx@archiver.kernel.org>; Tue, 17 Nov 2020 18:22:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="pS7q1QQV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731032AbgKQSWH (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 17 Nov 2020 13:22:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:60388 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730662AbgKQSWH (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 17 Nov 2020 13:22:07 -0500
Received: from kernel.org (83-245-197-237.elisa-laajakaista.fi [83.245.197.237])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 72F8520888;
        Tue, 17 Nov 2020 18:22:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605637326;
        bh=Tve6vesTOxkjJv5DWPTgqjxVjNCa2NCcmjrpx+RNrJ4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pS7q1QQVg3FuzXfG62R4O+L1vNktUsYj5MD94UEGM0viMuHQXUQ1+SdePEfCsvm41
         2Exf5qtmQbWOerMh2Lr143MuqB0UCXcnqAYnIpnh2RPG2I8mJjhV8P3hlO6BI6U9uJ
         DGWTndHSIRTQwkqa8/aooPC/QBsVi25hdUZiCmmQ=
Date:   Tue, 17 Nov 2020 20:22:01 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Hillf Danton <hdanton@sina.com>
Cc:     x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Jethro Beekman <jethro@fortanix.com>,
        Serge Ayoun <serge.ayoun@intel.com>, akpm@linux-foundation.org
Subject: Re: [PATCH v41 10/24] mm: Add 'mprotect' hook to struct
 vm_operations_struct
Message-ID: <20201117182201.GA10393@kernel.org>
References: <20201112220135.165028-1-jarkko@kernel.org>
 <20201115030548.1572-1-hdanton@sina.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20201115030548.1572-1-hdanton@sina.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Sun, Nov 15, 2020 at 11:05:48AM +0800, Hillf Danton wrote:
> On Fri, 13 Nov 2020 00:01:21 +0200
> > From: Sean Christopherson <sean.j.christopherson@intel.com>
> > 
> > Background
> > ==========
> > 
> > 1. SGX enclave pages are populated with data by copying from normal memory
> >    via ioctl() (SGX_IOC_ENCLAVE_ADD_PAGES), which will be added later in
> >    this series.
> > 2. It is desirable to be able to restrict those normal memory data sources.
> >    For instance, to ensure that the source data is executable before
> >    copying data to an executable enclave page.
> > 3. Enclave page permissions are dynamic (just like normal permissions) and
> >    can be adjusted at runtime with mprotect().
> > 
> > This creates a problem because the original data source may have long since
> > vanished at the time when enclave page permissions are established (mmap()
> > or mprotect()).
> > 
> > The solution (elsewhere in this series) is to force enclaves creators to
> > declare their paging permission *intent* up front to the ioctl().  This
> > intent can be immediately compared to the source data’s mapping and
> > rejected if necessary.
> > 
> > The “intent” is also stashed off for later comparison with enclave
> > PTEs. This ensures that any future mmap()/mprotect() operations
> > performed by the enclave creator or done on behalf of the enclave
> > can be compared with the earlier declared permissions.
> > 
> > Problem
> > =======
> > 
> > There is an existing mmap() hook which allows SGX to perform this
> > permission comparison at mmap() time.  However, there is no corresponding
> > ->mprotect() hook.
> > 
> > Solution
> > ========
> > 
> > Add a vm_ops->mprotect() hook so that mprotect() operations which are
> > inconsistent with any page's stashed intent can be rejected by the driver.
> > 
> > Cc: linux-mm@kvack.org
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Cc: Matthew Wilcox <willy@infradead.org>
> > Cc: Mel Gorman <mgorman@techsingularity.net>
> > Acked-by: Jethro Beekman <jethro@fortanix.com> # v40
> > Acked-by: Dave Hansen <dave.hansen@intel.com> # v40
> > # Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> > Co-developed-by: Jarkko Sakkinen <jarkko@kernel.org>
> > Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
> > ---
> 
> Acked-by: Hillf Danton <hdanton@sina.com>

Thank you.

/Jarkko
