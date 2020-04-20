Return-Path: <SRS0=jXpw=6E=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC2A8C54FD0
	for <linux-sgx@archiver.kernel.org>; Mon, 20 Apr 2020 21:52:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AFC4C2084D
	for <linux-sgx@archiver.kernel.org>; Mon, 20 Apr 2020 21:52:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726371AbgDTVwl (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 20 Apr 2020 17:52:41 -0400
Received: from mga17.intel.com ([192.55.52.151]:34522 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726361AbgDTVwl (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 20 Apr 2020 17:52:41 -0400
IronPort-SDR: uFQifRDvaJGjlcoqWzG8cWD7+KDi2dRic/Q4/pzVA+aAYJt1/conK+ubQ7cl9Pp4hrzA/+EJrO
 I+akjYJx6zMg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Apr 2020 14:52:40 -0700
IronPort-SDR: hoUgEpOf0grnEluN1CRoHe/ScBK8bKVJex5eDjLWFio8ry+B3fXifCP5mPlUXlGQmAJwquW5OA
 ceHQ/hTS/ZPQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,407,1580803200"; 
   d="scan'208";a="300406530"
Received: from rpirker-mobl2.ger.corp.intel.com (HELO localhost) ([10.252.46.184])
  by FMSMGA003.fm.intel.com with ESMTP; 20 Apr 2020 14:52:36 -0700
Date:   Tue, 21 Apr 2020 00:52:35 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Nathaniel McCallum <npmccallum@redhat.com>,
        Cedric Xing <cedric.xing@intel.com>,
        Jethro Beekman <jethro@fortanix.com>,
        Andy Lutomirski <luto@amacapital.net>,
        linux-sgx@vger.kernel.org
Subject: Re: [PATCH for_v29 v3 0/2]  x86/sgx: Make vDSO callable from C
Message-ID: <20200420215235.GC14637@linux.intel.com>
References: <20200418043609.29406-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200418043609.29406-1-sean.j.christopherson@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, Apr 17, 2020 at 09:36:07PM -0700, Sean Christopherson wrote:
> Nathaniel pointed out that __vdso_sgx_enter_enclave() is tantalizingly
> close to being callable from C (with caveats and a cooperative enclave).
> The missing pieces are preserving %rbx and taking @leaf as a standard
> parameter.

Cool, can live with these. Whining about obsolete details would be just
useless nonsense. I'll merge these and send v29 after that.

/Jarkko
