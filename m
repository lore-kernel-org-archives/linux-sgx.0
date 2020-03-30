Return-Path: <SRS0=pDj2=5P=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 069F6C43331
	for <linux-sgx@archiver.kernel.org>; Mon, 30 Mar 2020 20:35:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D120520757
	for <linux-sgx@archiver.kernel.org>; Mon, 30 Mar 2020 20:35:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727714AbgC3Ufm (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 30 Mar 2020 16:35:42 -0400
Received: from mga05.intel.com ([192.55.52.43]:34235 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727437AbgC3Ufm (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 30 Mar 2020 16:35:42 -0400
IronPort-SDR: bx6JRuqL196hW+A9RGhQovfxA8O9VfvxUlNB8GqU+JD4Qd+iUysS59JsoyHXQp330Dgg4Q8p+M
 58do3kqjHjfQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Mar 2020 13:35:41 -0700
IronPort-SDR: vn0PJcdzp3XoTjmkZlIuj7qe+fsxy3KJ01KU+ktixXq+RVDTsFQVG4L0B/WKWhjZfU1lrUQ7qc
 57387JbcagJQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,325,1580803200"; 
   d="scan'208";a="267046640"
Received: from plachner-mobl.ger.corp.intel.com (HELO localhost) ([10.252.35.129])
  by orsmga002.jf.intel.com with ESMTP; 30 Mar 2020 13:35:39 -0700
Date:   Mon, 30 Mar 2020 23:35:33 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     linux-sgx@vger.kernel.org
Subject: Re: [PATCH for_v29] selftests/sgx: Fix a benign linker warning
Message-ID: <20200330203533.GF1384380@linux.intel.com>
References: <20200330173120.28377-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200330173120.28377-1-sean.j.christopherson@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Mar 30, 2020 at 10:31:20AM -0700, Sean Christopherson wrote:
> Pass a build id of "none" to the linker to suppress a warning about the
> build id being ignored:
> 
>   /usr/bin/ld: warning: .note.gnu.build-id section discarded, --build-id
>   ignored.
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>

Thanks. Got idea from this that the ELF format used in the test could
be further refined with something like ".note.x86.tcs", which would
contain the start offset and size of the TCS list.

/Jarkko
