Return-Path: <SRS0=nWD/=5D=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EB0FC10DCE
	for <linux-sgx@archiver.kernel.org>; Wed, 18 Mar 2020 19:40:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0209C20772
	for <linux-sgx@archiver.kernel.org>; Wed, 18 Mar 2020 19:40:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726638AbgCRTkG (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 18 Mar 2020 15:40:06 -0400
Received: from mga01.intel.com ([192.55.52.88]:2241 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726631AbgCRTkG (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 18 Mar 2020 15:40:06 -0400
IronPort-SDR: zvwUTU5ojs6hT/Jk32/ORkDjVP1kf2aulqajYiOr+Tbt0tAwmbGS5EVcHM7b5F5rlfVdjUkjdp
 bji3aJ8dhW1Q==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Mar 2020 12:40:06 -0700
IronPort-SDR: Or19tXFDy8oaTOf4+0jP9YYUZ4XOkH3lGkAW2JYEoWD36mPuX44SjcK0Fc1PvuDC2amBYJoVgi
 bN9sEtSGBHCw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,568,1574150400"; 
   d="scan'208";a="391555940"
Received: from mbeldzik-mobl.ger.corp.intel.com (HELO localhost) ([10.252.55.127])
  by orsmga004.jf.intel.com with ESMTP; 18 Mar 2020 12:40:03 -0700
Date:   Wed, 18 Mar 2020 21:40:02 +0200
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     linux-sgx@vger.kernel.org
Subject: Re: [PATCH] x86/sgx: Fix deadlock and race conditions between fork()
 and EPC reclaim
Message-ID: <20200318194002.GA48177@linux.intel.com>
References: <20200317051539.10447-1-sean.j.christopherson@intel.com>
 <20200318153903.GA37333@linux.intel.com>
 <20200318155043.GA37726@linux.intel.com>
 <20200318160316.GE24357@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200318160316.GE24357@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Mar 18, 2020 at 09:03:16AM -0700, Sean Christopherson wrote:
> How on earth is someone doing to dredge up the above information without a
> comment?  Anyone looking at this code without a priori knowledge of the
> development history will assume the missing synchronize_srcu() is a bug.

By reading the source code of the driver obviously.

/Jarkko
