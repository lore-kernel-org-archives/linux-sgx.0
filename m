Return-Path: <SRS0=+C2n=X2=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28471ECE587
	for <linux-sgx@archiver.kernel.org>; Tue,  1 Oct 2019 20:23:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F02F1215EA
	for <linux-sgx@archiver.kernel.org>; Tue,  1 Oct 2019 20:23:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727197AbfJAUX3 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 1 Oct 2019 16:23:29 -0400
Received: from mga11.intel.com ([192.55.52.93]:47702 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727193AbfJAUX3 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 1 Oct 2019 16:23:29 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 01 Oct 2019 13:23:29 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,571,1559545200"; 
   d="scan'208";a="194641209"
Received: from nbaca1-mobl1.ger.corp.intel.com (HELO localhost) ([10.252.37.57])
  by orsmga003.jf.intel.com with ESMTP; 01 Oct 2019 13:23:18 -0700
Date:   Tue, 1 Oct 2019 23:23:17 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org,
        x86@kernel.org, linux-sgx@vger.kernel.org,
        akpm@linux-foundation.org, dave.hansen@intel.com,
        nhorman@redhat.com, npmccallum@redhat.com, serge.ayoun@intel.com,
        shay.katz-zamir@intel.com, haitao.huang@intel.com,
        andriy.shevchenko@linux.intel.com, tglx@linutronix.de,
        kai.svahn@intel.com, josh@joshtriplett.org, luto@kernel.org,
        kai.huang@intel.com, rientjes@google.com, cedric.xing@intel.com
Subject: Re: [PATCH v22 05/24] x86/sgx: Add ENCLS architectural error codes
Message-ID: <20191001202317.GD12699@linux.intel.com>
References: <20190903142655.21943-1-jarkko.sakkinen@linux.intel.com>
 <20190903142655.21943-6-jarkko.sakkinen@linux.intel.com>
 <20190927102013.GA23002@zn.tnic>
 <20190927160842.GL10545@linux.intel.com>
 <20190927172012.GE25513@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190927172012.GE25513@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, Sep 27, 2019 at 10:20:12AM -0700, Sean Christopherson wrote:
> Please keep all error codes.  For errors that inevitably occur during
> development, it's very helpful to have the complete list in the kernel
> (well, reasonably complete).  I hate having to open and search through the
> SDM just to decipher a random numeric error code.

Unfortunately I choose here the otherwise because they serve no semantic
purpose. That is clutter by definition.

What I do is that when there is a new version of SDM I just print to
pages defining the error codes. I also keep manual "sdm-3d.pdf" all the
time open in Firefox.

I can understand your grief if you have a single PDF SDM but the purpose
of Linux GIT tree is not to fix your workflows :-) You can easily fix
them yourself.

/Jarkko
