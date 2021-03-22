Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C28E4C433DB
	for <linux-sgx@archiver.kernel.org>; Mon, 22 Mar 2021 22:24:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 92F09619A8
	for <linux-sgx@archiver.kernel.org>; Mon, 22 Mar 2021 22:24:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230189AbhCVWXi (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 22 Mar 2021 18:23:38 -0400
Received: from mga03.intel.com ([134.134.136.65]:4942 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229962AbhCVWXM (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 22 Mar 2021 18:23:12 -0400
IronPort-SDR: KoGGHElcLEMSDWFiyLRHLHdoNkrczk9RJmhIO4d2S0RskR9HbDWl51nUAuKJ6cHkvE3WY2fzih
 li6MRsg6zOoA==
X-IronPort-AV: E=McAfee;i="6000,8403,9931"; a="190385783"
X-IronPort-AV: E=Sophos;i="5.81,269,1610438400"; 
   d="scan'208";a="190385783"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2021 15:23:10 -0700
IronPort-SDR: 3jsiOqLOE4m5ve2B6I2lRNLY4iIVViTRm52ah8zfS5lW31FxyyIUtvOScKaGtuY7PfJmOm70lV
 Fw0cnDmRZu6Q==
X-IronPort-AV: E=Sophos;i="5.81,269,1610438400"; 
   d="scan'208";a="381133556"
Received: from rmarinax-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.252.143.198])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2021 15:23:06 -0700
Date:   Tue, 23 Mar 2021 11:23:03 +1300
From:   Kai Huang <kai.huang@intel.com>
To:     Borislav Petkov <bp@alien8.de>
Cc:     Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
        x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org, jarkko@kernel.org, luto@kernel.org,
        dave.hansen@intel.com, rick.p.edgecombe@intel.com,
        haitao.huang@intel.com, pbonzini@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com
Subject: Re: [PATCH v3 03/25] x86/sgx: Wipe out EREMOVE from
 sgx_free_epc_page()
Message-Id: <20210323112303.5eddd954ee601fca00b37aa3@intel.com>
In-Reply-To: <20210322210645.GI6481@zn.tnic>
References: <cover.1616136307.git.kai.huang@intel.com>
        <062acb801926b2ade2f9fe1672afb7113453a741.1616136308.git.kai.huang@intel.com>
        <20210322181646.GG6481@zn.tnic>
        <YFjoZQwB7e3oQW8l@google.com>
        <20210322191540.GH6481@zn.tnic>
        <YFjx3vixDURClgcb@google.com>
        <20210322210645.GI6481@zn.tnic>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org


> 
> Btw, I probably have seen this and forgotten again so pls remind me,
> is the amount of pages available for SGX use static and limited by,
> I believe BIOS, or can a leakage in EPC pages cause system memory
> shortage?
> 

Yes EPC size is fixed and configured in BIOS. Leaking EPC pages may cause EPC
shortage, but not system memory.
