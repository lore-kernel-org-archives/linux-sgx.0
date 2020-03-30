Return-Path: <SRS0=pDj2=5P=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABA81C43331
	for <linux-sgx@archiver.kernel.org>; Mon, 30 Mar 2020 20:48:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8BB3A20757
	for <linux-sgx@archiver.kernel.org>; Mon, 30 Mar 2020 20:48:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727750AbgC3Usn (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 30 Mar 2020 16:48:43 -0400
Received: from mga14.intel.com ([192.55.52.115]:45302 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727437AbgC3Usn (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 30 Mar 2020 16:48:43 -0400
IronPort-SDR: iBR6p2Ln1iJB+JNK89HoTFchtWjRbo0tjzq+iPdMPjZqPOhsFTnveFsMiow5Nq6GLKIZzy7Oec
 j6Bp8eVD0NOQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Mar 2020 13:48:43 -0700
IronPort-SDR: usxkdiDTrwHNijGjSkPCXts+dFxZnxEFj1nqJAohWz/daP23O+qu70YSaEkBDvLx5Z2JbmAJZ7
 vVjAIL1txO5Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,325,1580803200"; 
   d="scan'208";a="448412210"
Received: from plachner-mobl.ger.corp.intel.com (HELO localhost) ([10.252.35.129])
  by fmsmga005.fm.intel.com with ESMTP; 30 Mar 2020 13:48:40 -0700
Date:   Mon, 30 Mar 2020 23:48:39 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Nathaniel McCallum <npmccallum@redhat.com>,
        Cedric Xing <cedric.xing@intel.com>,
        Jethro Beekman <jethro@fortanix.com>,
        Andy Lutomirski <luto@amacapital.net>,
        linux-sgx@vger.kernel.org
Subject: Re: [PATCH for_v29 v2 0/5]  x86/sgx: Make vDSO callable from C
Message-ID: <20200330204839.GH1384380@linux.intel.com>
References: <20200330180811.31381-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200330180811.31381-1-sean.j.christopherson@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Mar 30, 2020 at 11:08:06AM -0700, Sean Christopherson wrote:
> Nathaniel pointed out that __vdso_sgx_enter_enclave() is tantalizingly
> close to being callable from C (with caveats and a cooperative enclave).
> The missing pieces are preserving %rbx and taking @leaf as a standard
> parameter.
> 
> v2:
>   - Rebase to Jarkko's latest master, commit 402fb35a477a, "docs: ...")
>   - Add CFI directive for RBX. [Cedric]

I'm sorry for throwing stick's constantly but I think having a real
ELF loader is for better.

/Jarkko
