Return-Path: <SRS0=qxyk=5A=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D1B2C10DCE
	for <linux-sgx@archiver.kernel.org>; Sun, 15 Mar 2020 18:11:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5FFFB206B1
	for <linux-sgx@archiver.kernel.org>; Sun, 15 Mar 2020 18:11:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729003AbgCOSLb (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sun, 15 Mar 2020 14:11:31 -0400
Received: from mga03.intel.com ([134.134.136.65]:42958 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728999AbgCOSLa (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Sun, 15 Mar 2020 14:11:30 -0400
IronPort-SDR: 6MzYqeXnBNyzSzC9UkGQ91r+HZkzh61xWNY1ir8cmuXzIUSODOQw4siBENJkWMUWq73yyneFSX
 LyaZHFJvTqdg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2020 11:11:30 -0700
IronPort-SDR: Dz7ieMD6YbIarGIIj9I7H7i6P+Cir0lAGlBbKc+gvfnIw4a2DNUyYH5dJytDsPsGGHHAfO5iuh
 eZDpewitUyVA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,557,1574150400"; 
   d="scan'208";a="278801859"
Received: from babayass-mobl.ger.corp.intel.com (HELO localhost) ([10.249.90.210])
  by fmsmga002.fm.intel.com with ESMTP; 15 Mar 2020 11:11:27 -0700
Date:   Sun, 15 Mar 2020 20:11:26 +0200
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     linux-sgx@vger.kernel.org
Subject: Re: [PATCH] x86/sgx: Fix a build error introduced by
 WARN->ENCLS_WARN conversion
Message-ID: <20200315181126.GA224162@linux.intel.com>
References: <20200314033051.32137-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200314033051.32137-1-sean.j.christopherson@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, Mar 13, 2020 at 08:30:51PM -0700, Sean Christopherson wrote:
> Remove an unwanted param when invoking ENCLS_WARN on EREMOVE failure.
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>

Applied [1].

Had not set $LINUX_OVERRIDE_SRCDIR when building my BuildRoot
environment which caused buildroot to pull remote version of the kernel
tree instead of local. I.e. ended up compiling kernel without the change
that caused this compilation failure.

/Jarkko
