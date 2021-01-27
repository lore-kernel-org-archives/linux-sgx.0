Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53C9CC43331
	for <linux-sgx@archiver.kernel.org>; Wed, 27 Jan 2021 02:49:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 35B95206C3
	for <linux-sgx@archiver.kernel.org>; Wed, 27 Jan 2021 02:49:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231196AbhA0Csl (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 26 Jan 2021 21:48:41 -0500
Received: from mga06.intel.com ([134.134.136.31]:24583 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392099AbhA0B1j (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 26 Jan 2021 20:27:39 -0500
IronPort-SDR: L9ztlzhSm0GCY6A4hkLIWwsV7lHmu+k7WahuuC+4Yw9tsZ1eycZ0kSlQkfKNYuqxd8XH7sEsvn
 M3ajbmHc/FXg==
X-IronPort-AV: E=McAfee;i="6000,8403,9876"; a="241528892"
X-IronPort-AV: E=Sophos;i="5.79,378,1602572400"; 
   d="scan'208";a="241528892"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2021 17:26:58 -0800
IronPort-SDR: 2lxFsebB69rfL0VoECsy/l58SmJ27smHpB+kWfYuQBIxDz58LKPpz5BMlMEBV80seamygTbueZ
 mD5mDAylFd4g==
X-IronPort-AV: E=Sophos;i="5.79,378,1602572400"; 
   d="scan'208";a="353637758"
Received: from rsperry-desk.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.251.7.187])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2021 17:26:54 -0800
Date:   Wed, 27 Jan 2021 14:26:52 +1300
From:   Kai Huang <kai.huang@intel.com>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     <linux-sgx@vger.kernel.org>, <kvm@vger.kernel.org>,
        <x86@kernel.org>, <seanjc@google.com>, <jarkko@kernel.org>,
        <luto@kernel.org>, <haitao.huang@intel.com>, <pbonzini@redhat.com>,
        <bp@alien8.de>, <tglx@linutronix.de>, <mingo@redhat.com>,
        <hpa@zytor.com>
Subject: Re: [RFC PATCH v3 03/27] x86/sgx: Remove a warn from
 sgx_free_epc_page()
Message-Id: <20210127142652.b9d181813b10f8660d0df664@intel.com>
In-Reply-To: <15dda40e-5875-aaa9-acbb-7d868a13f982@intel.com>
References: <cover.1611634586.git.kai.huang@intel.com>
        <36e999dce8a1a4efb8ca69c9a6fbe3fa63305e08.1611634586.git.kai.huang@intel.com>
        <d09b8b34-6e8c-5323-e155-f45da5abb48b@intel.com>
        <6e859dc6610d317f09663a4ce76b7e13fc0c0f8e.camel@intel.com>
        <15dda40e-5875-aaa9-acbb-7d868a13f982@intel.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, 26 Jan 2021 17:12:12 -0800 Dave Hansen wrote:
> On 1/26/21 5:08 PM, Kai Huang wrote:
> > I don't have deep understanding of SGX driver. Would you help to answer?
> 
> Kai, as the patch submitter, you are expected to be able to at least
> minimally explain what the patch is doing.  Please endeavor to obtain
> this understanding before sending patches in the future.

I see. Thanks.
