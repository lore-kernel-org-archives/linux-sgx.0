Return-Path: <SRS0=xedp=5E=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1E42C4332D
	for <linux-sgx@archiver.kernel.org>; Thu, 19 Mar 2020 14:24:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9F9F02098B
	for <linux-sgx@archiver.kernel.org>; Thu, 19 Mar 2020 14:24:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726933AbgCSOYg (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 19 Mar 2020 10:24:36 -0400
Received: from mga18.intel.com ([134.134.136.126]:23078 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726926AbgCSOYg (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 19 Mar 2020 10:24:36 -0400
IronPort-SDR: p1y22+B1gfvgi9+aaMbamEKsn507qTXuKrLn4hyz8kGNeoYEdoZuMj3bLz5TJgixZhzNRsMn5d
 r03IN82Bi/rA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Mar 2020 07:24:35 -0700
IronPort-SDR: 2l4qg8YwKeoMEp78ZB9CNxSjCF1ORZVHyHRhMRWMT+HQb7L/nXHuIpcwy5eFEGvQvbV4jiGQLO
 Q5Yaps+SUo8g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,571,1574150400"; 
   d="scan'208";a="268747280"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by fmsmga004.fm.intel.com with ESMTP; 19 Mar 2020 07:24:34 -0700
Date:   Thu, 19 Mar 2020 07:24:35 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jethro Beekman <jethro@fortanix.com>
Cc:     "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        assaf@enigma.co
Subject: Re: SGX device & noexec /dev
Message-ID: <20200319142434.GA11305@linux.intel.com>
References: <4db41057-910c-b686-0428-474debe382c1@fortanix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4db41057-910c-b686-0428-474debe382c1@fortanix.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Mar 19, 2020 at 12:50:05PM +0100, Jethro Beekman wrote:
> Hi all,
> 
> One of our users discovered that some distros (notably at least Ubuntu 20.04)
> mount /dev noexec. This prevents mmap(PROT_EXEC) on the SGX device. Do we
> have any recourse other than telling distros not to do this if they want to
> support SGX?

Hmm, going the anon inode approach should avoid that issue, but then folks
running SELinux get the short end of the stick due to EXECMEM triggering.
The SELinux issue can be hacked around, e.g. by adding a way to identify
that a file is an enclave.  A similar hack would work for noexec, though
it'd likely be an even uglier hack.
