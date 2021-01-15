Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB278C433DB
	for <linux-sgx@archiver.kernel.org>; Fri, 15 Jan 2021 10:20:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8E303235F9
	for <linux-sgx@archiver.kernel.org>; Fri, 15 Jan 2021 10:20:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726507AbhAOKU3 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 15 Jan 2021 05:20:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:57314 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726385AbhAOKUR (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 15 Jan 2021 05:20:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AD1C8235F9;
        Fri, 15 Jan 2021 10:19:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610705977;
        bh=bf0jQ2O0tO4O/8qlgaE5+O21nA4lPigurpD7Qz3bnAA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Jk1VDTw2wrccTJWzhst5krnjAqTHk/VuQjLsYhD7KP/Uz8MXpaKPINNbg7OYFt+KC
         obDmPNXEOHahdIKfTVUPPeIdQukJPqV+ncUHpVTcvqjUQpt74idSvp+KKVM5KbrzsP
         VpO6EKJ9SYlK80kJ8JD47qf689xQ2k9DTUiDX896RvvQkCkAwxWExkoCyNaiq1AOo5
         l31Xr7QWNLwvpeKzVYd8GXqOdNzUAeWditxIj6ZE0DDgQVgVU6dlphSLkMSGsKDDaO
         qRbanA9N+c0sUsgfwI3RscYlyNBFXAePnAwwLv3OOLRCeym5PbDGbgIIWMIB2w3vGO
         L5H1gwu3/iscQ==
Date:   Fri, 15 Jan 2021 12:19:32 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org,
        linux-sgx@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Jiri Kosina <trivial@kernel.org>
Subject: Re: [PATCH RFC] x86/sgx: Add trivial NUMA allocation
Message-ID: <YAFsNJZgyzfkYoSR@kernel.org>
References: <20201216135031.21518-1-jarkko@kernel.org>
 <34b1acd1-e769-0dc2-a225-8ce3d2b6a085@intel.com>
 <YACFasdDi0siM2ML@kernel.org>
 <16b26a00-eb6b-7c19-6c33-144efe516b6b@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <16b26a00-eb6b-7c19-6c33-144efe516b6b@intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Jan 14, 2021 at 10:35:03AM -0800, Dave Hansen wrote:
> On 1/14/21 9:54 AM, Jarkko Sakkinen wrote:
> > On Tue, Jan 12, 2021 at 04:24:01PM -0800, Dave Hansen wrote:
> >> We need a bit more information here as well.  What's the relationship
> >> between NUMA nodes and sections?  How does the BIOS tell us which NUMA
> >> nodes a section is in?  Is it the same or different from normal RAM and
> >> PMEM?
> > 
> > How does it go with pmem?
> 
> I just wanted to point out PMEM as being referred to by the SRAT, but as
> something which is *not* "System RAM".  There might be some overlap in
> NUMA for PMEM and NUMA for SGX memory since neither is enumerated as
> "System RAM".

Right.

> ...
> >> I'm not positive this works.  I *thought* these ->node_start_pfn and
> >> ->node_spanned_pages are really only guaranteed to cover memory which is
> >> managed by the kernel and has 'struct page' for it.
> >>
> >> EPC doesn't have a 'struct page', so won't necessarily be covered by the
> >> pgdat-> and zone-> ranges.  I *think* you may have to go all the way
> >> back to the ACPI SRAT for this.
> >>
> >> It would also be *possible* to have an SRAT constructed like this:
> >>
> >> 0->1GB System RAM - Node 0
> >> 1->2GB Reserved   - Node 1
> >> 2->3GB System RAM - Node 0
> >>
> >> Where the 1->2GB is EPC.  The Node 0 pg_data_t would be:
> >>
> >> 	pgdat->node_start_pfn = 0
> >> 	pgdat->node_spanned_pages = 3GB
> > 
> > If I've understood the current Linux memory architecture correctly.
> > 
> > - Memory is made available through mm/memory_hotplug.c, which is populated
> >   by drivers/acpi/acpi_memhotplug.c.
> > - drivers/acpi/numa/srat.c provides the conversion API from proximity node to
> >   logical node but I'm not *yet* sure how the interaction goes with memory
> >   hot plugging
> > 
> > I'm not sure of I'm following the idea of alternative SRAT construciton.
> > So are you saying that srat.c would somehow group pxm's with EPC to
> > specific node numbers?
> 
> Basically, go look at the "SRAT:" messages in boot.  Are there SRAT
> entries that cover all the EPC?  For instance, take this SRAT:
> 
> [    0.000000] ACPI: SRAT: Node 1 PXM 2 [mem 0x00000000-0xcfffffff]
> [    0.000000] ACPI: SRAT: Node 1 PXM 2 [mem 0x100000000-0x82fffffff]
> [    0.000000] ACPI: SRAT: Node 0 PXM 1 [mem 0x830000000-0xe2fffffff]

Right!

> If EPC were at 0x100000000, we would be in good shape.  It is covered by
> an SRAT entry that Linux parses as RAM.  But, if it were at 0xd0000000,
> it would be in an SRAT "hole", uncovered by an SRAT entry.  In this
> case, since 'Node 1" spans that hole the "Node 1" pgdat would span this
> hole.  But, if some memory was removed from the system, "Node 1" might
> no longer span that hole and EPC in this hole would not be assignable to
> Node 1.
> 
> Please just make sure that there *ARE* SRAT entries that cover EPC
> memory ranges.

OK, I'm on page now, thanks.

/Jarkko
