Return-Path: <SRS0=qxyk=5A=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 250B6C1975A
	for <linux-sgx@archiver.kernel.org>; Sun, 15 Mar 2020 01:45:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 06D9E2071B
	for <linux-sgx@archiver.kernel.org>; Sun, 15 Mar 2020 01:45:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726549AbgCOBpG (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sat, 14 Mar 2020 21:45:06 -0400
Received: from mga11.intel.com ([192.55.52.93]:57711 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726125AbgCOBpF (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Sat, 14 Mar 2020 21:45:05 -0400
IronPort-SDR: T8YLneuB+tgoUYdmfCsK4H9zfs4txjjDT2dDvSRynNfrtZeSxaPW6jE5mo2BYfGn6F5ZyvGGVy
 eLpCKbdseBCg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2020 18:17:29 -0700
IronPort-SDR: 6RZRYafgPr/dTqPERjsHs00TLV2/oN1wh7Y98ZQe0lQURHbYBWQTKE2DfWxEh7+0TXgADhre3K
 6vvOprMCAkGw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,554,1574150400"; 
   d="scan'208";a="323143854"
Received: from mbenhamu-mobl2.ger.corp.intel.com (HELO localhost) ([10.251.177.145])
  by orsmga001.jf.intel.com with ESMTP; 14 Mar 2020 18:17:15 -0700
Date:   Sun, 15 Mar 2020 03:17:13 +0200
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-sgx@vger.kernel.org, akpm@linux-foundation.org,
        dave.hansen@intel.com, nhorman@redhat.com, npmccallum@redhat.com,
        haitao.huang@intel.com, andriy.shevchenko@linux.intel.com,
        tglx@linutronix.de, kai.svahn@intel.com, bp@alien8.de,
        josh@joshtriplett.org, luto@kernel.org, kai.huang@intel.com,
        rientjes@google.com, cedric.xing@intel.com, puiterwijk@redhat.com,
        linux-mm@kvack.org, Ismo Puustinen <ismo.puustinen@intel.com>,
        Mark Shanahan <mark.shanahan@intel.com>,
        Mikko Ylinen <mikko.ylinen@intel.com>,
        Derek Bombien <derek.bombien@intel.com>
Subject: Re: [PATCH v28 16/22] x86/sgx: Add a page reclaimer
Message-ID: <20200315011713.GB208715@linux.intel.com>
References: <20200303233609.713348-1-jarkko.sakkinen@linux.intel.com>
 <20200303233609.713348-17-jarkko.sakkinen@linux.intel.com>
 <20200305190354.GK11500@linux.intel.com>
 <20200306184702.GD7472@linux.intel.com>
 <20200312183824.GB26453@linux.intel.com>
 <20200315002732.GA208715@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200315002732.GA208715@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Sun, Mar 15, 2020 at 02:27:46AM +0200, Jarkko Sakkinen wrote:
> On Thu, Mar 12, 2020 at 11:38:24AM -0700, Sean Christopherson wrote:
> > On Fri, Mar 06, 2020 at 08:47:02PM +0200, Jarkko Sakkinen wrote:
> > > On Thu, Mar 05, 2020 at 11:03:54AM -0800, Sean Christopherson wrote:
> > > > We've also discussed taking a file descriptor to hold the backing, but
> > > > unless I'm misreading the pagecache code, that doesn't solve the incorrect
> > > > accounting problem because the current task, i.e. evicting task, would be
> > > > charged.  In other words, whether the backing is kernel or user controlled
> > > > is purely an ABI question.
> > > 
> > > Even if the file is owned by a different process the account happens
> > > to "current"?
> > 
> > Yes.  Which makes sense as files do not have a 1:1 association with tasks.
> 
> Yeah, that makes sense. Looking at mm/memory.c.
> 
> Looking at finish_fault/alloc_set_pte/inc_mm_counter_fast code path that
> is also what happens.

Ugh, I meant __set_page_dirty/account_page_dirtied/task_io_account_write
path :-/ Anyway.

/Jarkko
