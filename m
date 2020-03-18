Return-Path: <SRS0=nWD/=5D=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F26CC4332B
	for <linux-sgx@archiver.kernel.org>; Wed, 18 Mar 2020 21:30:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5BBA920772
	for <linux-sgx@archiver.kernel.org>; Wed, 18 Mar 2020 21:30:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726894AbgCRVa6 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 18 Mar 2020 17:30:58 -0400
Received: from mga09.intel.com ([134.134.136.24]:21288 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726747AbgCRVa5 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 18 Mar 2020 17:30:57 -0400
IronPort-SDR: iGAHibvlfb56VzH1Y0zyKxDZo+cW+7z0LrQqB0msPB+ektQX82TPy9J+445Q7ro3dbsQ92EDar
 VAeaTC2/4vug==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Mar 2020 14:30:57 -0700
IronPort-SDR: peWy+ceIR9XMCmBD0WAbGZB9lh3uxN4R6Kdi6bme+l9YmXW3Bcqs6VxHn/9nzk2Tvp6rdiMwwc
 UYIM3q4tG3wQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,569,1574150400"; 
   d="scan'208";a="238305991"
Received: from mbeldzik-mobl.ger.corp.intel.com (HELO localhost) ([10.252.55.127])
  by fmsmga008.fm.intel.com with ESMTP; 18 Mar 2020 14:30:55 -0700
Date:   Wed, 18 Mar 2020 23:30:54 +0200
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     linux-sgx@vger.kernel.org
Subject: Re: [PATCH] x86/sgx: Fix deadlock and race conditions between fork()
 and EPC reclaim
Message-ID: <20200318213054.GA50727@linux.intel.com>
References: <20200317051539.10447-1-sean.j.christopherson@intel.com>
 <20200318153903.GA37333@linux.intel.com>
 <20200318155043.GA37726@linux.intel.com>
 <20200318160316.GE24357@linux.intel.com>
 <20200318194002.GA48177@linux.intel.com>
 <20200318194132.GB48177@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200318194132.GB48177@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Mar 18, 2020 at 09:41:35PM +0200, Jarkko Sakkinen wrote:
> On Wed, Mar 18, 2020 at 09:40:06PM +0200, Jarkko Sakkinen wrote:
> > On Wed, Mar 18, 2020 at 09:03:16AM -0700, Sean Christopherson wrote:
> > > How on earth is someone doing to dredge up the above information without a
> > > comment?  Anyone looking at this code without a priori knowledge of the
> > > development history will assume the missing synchronize_srcu() is a bug.
> > 
> > By reading the source code of the driver obviously.
> 
> Secondly, there is no development history. It is in epoch state.

One bigger artifact that I noticed is that a loop construct
would be better than looping with goto. do-while would fit
just fine.

/Jarkko
