Return-Path: <SRS0=E9YI=32=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51086C352A2
	for <linux-sgx@archiver.kernel.org>; Thu,  6 Feb 2020 15:35:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2796122314
	for <linux-sgx@archiver.kernel.org>; Thu,  6 Feb 2020 15:35:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727457AbgBFPf0 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 6 Feb 2020 10:35:26 -0500
Received: from mga03.intel.com ([134.134.136.65]:36383 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725535AbgBFPfZ (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 6 Feb 2020 10:35:25 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Feb 2020 07:35:25 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,410,1574150400"; 
   d="scan'208";a="432250596"
Received: from dgbrowne-mobl.ger.corp.intel.com (HELO localhost) ([10.252.14.106])
  by fmsmga006.fm.intel.com with ESMTP; 06 Feb 2020 07:35:20 -0800
Date:   Thu, 6 Feb 2020 17:35:19 +0200
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-sgx@vger.kernel.org, akpm@linux-foundation.org,
        dave.hansen@intel.com, nhorman@redhat.com, npmccallum@redhat.com,
        haitao.huang@intel.com, andriy.shevchenko@linux.intel.com,
        tglx@linutronix.de, kai.svahn@intel.com, bp@alien8.de,
        josh@joshtriplett.org, luto@kernel.org, kai.huang@intel.com,
        rientjes@google.com, cedric.xing@intel.com, puiterwijk@redhat.com,
        Serge Ayoun <serge.ayoun@intel.com>
Subject: Re: [PATCH v25 07/21] x86/sgx: Enumerate and track EPC sections
Message-ID: <20200206153519.GB9694@linux.intel.com>
References: <20200204060545.31729-1-jarkko.sakkinen@linux.intel.com>
 <20200204060545.31729-8-jarkko.sakkinen@linux.intel.com>
 <20200205195700.GJ4877@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200205195700.GJ4877@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Feb 05, 2020 at 11:57:00AM -0800, Sean Christopherson wrote:
>   3. Breaks on-demand paging when running in a VM, e.g. if the VMM chooses
>      to allocate a physical EPC page when it's actually accessed by the
>      VM.  I don't expect this to be a problem any time soon, as all VMMs
>      will likely preallocate EPC pages until KVM (or any other hypervisor)
>      gains EPC oversusbscription support, which may or may not ever happen.
>      But, I'd prefer to simply not have the problem in the first place.

So wouldn't it be better to revisit this when the VM changes are added.

/Jarkko
