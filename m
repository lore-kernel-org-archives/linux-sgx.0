Return-Path: <SRS0=dBTT=5F=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9265FC4332B
	for <linux-sgx@archiver.kernel.org>; Fri, 20 Mar 2020 17:52:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 720E020663
	for <linux-sgx@archiver.kernel.org>; Fri, 20 Mar 2020 17:52:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726801AbgCTRwS (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 20 Mar 2020 13:52:18 -0400
Received: from mga02.intel.com ([134.134.136.20]:4340 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725446AbgCTRwS (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 20 Mar 2020 13:52:18 -0400
IronPort-SDR: S4tgZZ4MtZea+9b8KfCPajAZV7s8SE2DFgC1c+Hrnw0KUOUwJwEZ4x5TR3uZk370oaK1a9QIfQ
 1eXIDiQbsgNw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2020 10:52:17 -0700
IronPort-SDR: QEP90BZ4pq99MtucFo9S5UbTGdqQZlb9x9xw5bHqjfFOCUuBnDCe4YraEbmvxVgSo73yK7xuCw
 oTvKa3s0fLeg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,285,1580803200"; 
   d="scan'208";a="239292562"
Received: from aklimker-mobl1.ger.corp.intel.com (HELO localhost) ([10.255.197.99])
  by orsmga008.jf.intel.com with ESMTP; 20 Mar 2020 10:52:14 -0700
Date:   Fri, 20 Mar 2020 19:52:12 +0200
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     linux-sgx@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>
Subject: Re: [PATCH 2/2] selftests/x86/sgx: Move to selftests/sgx
Message-ID: <20200320175212.GA166291@linux.intel.com>
References: <20200320174716.27944-1-jarkko.sakkinen@linux.intel.com>
 <20200320174716.27944-2-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200320174716.27944-2-jarkko.sakkinen@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, Mar 20, 2020 at 07:47:16PM +0200, Jarkko Sakkinen wrote:
> Move selftest under the top level selftests directory so that we don't
> need to clutter x86/Makefile. The changes made for x86/Makefile caused
> also issues with packaging the selftests. Finally, SGX assets need their
> own tailored compilation environment.
> 
> With this change BuildRoot nicely packages both standard x86 selftests
> and our SGX test.
> 
> Cc: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>

Promise that this my last update to selftests. Just wanted to hammer
these quickly to cause minimum amount of distraction with the other
patch set. Otherwise, would be very hard to focus on reviewing those
chages. The changes I've done I think are no brainers. That's why I
don't hold for long before merging.

/Jarkko
