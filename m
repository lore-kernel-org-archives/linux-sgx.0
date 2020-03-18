Return-Path: <SRS0=nWD/=5D=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 428DEC10DCE
	for <linux-sgx@archiver.kernel.org>; Wed, 18 Mar 2020 15:51:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1F41120768
	for <linux-sgx@archiver.kernel.org>; Wed, 18 Mar 2020 15:51:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726817AbgCRPvu (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 18 Mar 2020 11:51:50 -0400
Received: from mga18.intel.com ([134.134.136.126]:52702 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726619AbgCRPvu (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 18 Mar 2020 11:51:50 -0400
IronPort-SDR: 6yDq6uj5se7po+0G6gtKqhkDT312nHz/wxKjaMcFtW004H4l4YYgHq+u0/zm9cXpBfWLq122tG
 S4UrH1jx8GGA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Mar 2020 08:51:50 -0700
IronPort-SDR: 8iYTND+M5eydpqS0xxo33oTsPpGVA8LhbrjyizpGX2gCVkdVUSCm5Y7XNpItumdwzDj4gUMFKl
 ea6AcE6YFJTg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,568,1574150400"; 
   d="scan'208";a="417993635"
Received: from mbeldzik-mobl.ger.corp.intel.com (HELO localhost) ([10.252.55.127])
  by orsmga005.jf.intel.com with ESMTP; 18 Mar 2020 08:51:47 -0700
Date:   Wed, 18 Mar 2020 17:51:45 +0200
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     linux-sgx@vger.kernel.org
Subject: Re: [PATCH] x86/sgx: Fix deadlock and race conditions between fork()
 and EPC reclaim
Message-ID: <20200318155145.GB37726@linux.intel.com>
References: <20200317051539.10447-1-sean.j.christopherson@intel.com>
 <20200318153903.GA37333@linux.intel.com>
 <20200318155043.GA37726@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200318155043.GA37726@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Mar 18, 2020 at 05:50:47PM +0200, Jarkko Sakkinen wrote:
> > > +	/*
> > > +	 * DO NOT call synchronize_srcu()!  When this is called via dup_mmap(),
> > > +	 * mmap_sem is held for write in both the old mm and new mm, and the
> > > +	 * reclaimer may be holding srcu for read while waiting on down_read()
> > > +	 * for the old mm's mmap_sem, i.e. synchronizing will deadlock.
> > > +	 * Incrementing the list version ensures readers that must not race
> > > +	 * with a mm being added will see the updated list.
> > > +	 */
> 
> For this comment, please completely remove it. We either call something
> or do not call it. We do !call anything.

Was meaning to say that we do not !call anything.

/Jarkko
