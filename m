Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 736CBC433DB
	for <linux-sgx@archiver.kernel.org>; Thu,  7 Jan 2021 01:39:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4B56422E00
	for <linux-sgx@archiver.kernel.org>; Thu,  7 Jan 2021 01:39:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725860AbhAGBjm (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 6 Jan 2021 20:39:42 -0500
Received: from mga17.intel.com ([192.55.52.151]:48257 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725822AbhAGBjm (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 6 Jan 2021 20:39:42 -0500
IronPort-SDR: gCK4z46qJUktLLh+3FC6v1x4TdQvrTPLIkcyx8uImkV8QDLQZ03EV0EYgtpJO+nkNfyQl+D27q
 a0IXtwhsmBbQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9856"; a="157142700"
X-IronPort-AV: E=Sophos;i="5.79,328,1602572400"; 
   d="scan'208";a="157142700"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2021 17:39:02 -0800
IronPort-SDR: EdZDSLnrykEpEI/YIFx2ASC6fAtw8AXOxsRXVKdriNvY0jQgl9GvkkIHbblXdrM2QJH/4NtQcu
 UIUmLcLlL1xg==
X-IronPort-AV: E=Sophos;i="5.79,328,1602572400"; 
   d="scan'208";a="351077237"
Received: from naljabex-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.254.117.182])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2021 17:38:58 -0800
Date:   Thu, 7 Jan 2021 14:38:55 +1300
From:   Kai Huang <kai.huang@intel.com>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        <linux-sgx@vger.kernel.org>, <kvm@vger.kernel.org>,
        <x86@kernel.org>, <jarkko@kernel.org>, <luto@kernel.org>,
        <haitao.huang@intel.com>, <pbonzini@redhat.com>, <bp@alien8.de>,
        <tglx@linutronix.de>, <mingo@redhat.com>, <hpa@zytor.com>
Subject: Re: [RFC PATCH 03/23] x86/sgx: Introduce virtual EPC for use by KVM
 guests
Message-Id: <20210107143855.b316478af5d94ffa89bd6f41@intel.com>
In-Reply-To: <33d9bec8-9427-b9cd-a9fb-ca5c44e4d2fe@intel.com>
References: <cover.1609890536.git.kai.huang@intel.com>
        <ace9d4cb10318370f6145aaced0cfa73dda36477.1609890536.git.kai.huang@intel.com>
        <2e424ff3-51cb-d6ed-6c5f-190e1d4fe21a@intel.com>
        <X/YfE28guNBxcpui@google.com>
        <20210107134758.ba0b5d950282973eaefe1ded@intel.com>
        <33d9bec8-9427-b9cd-a9fb-ca5c44e4d2fe@intel.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, 6 Jan 2021 16:52:49 -0800 Dave Hansen wrote:
> On 1/6/21 4:47 PM, Kai Huang wrote:
> >>>> +	ret = __eremove(sgx_get_epc_virt_addr(epc_page));
> >>>> +	if (ret) {
> >>>> +		/*
> >>>> +		 * Only SGX_CHILD_PRESENT is expected, which is because of
> >>>> +		 * EREMOVE-ing an SECS still with child, in which case it can
> >>>> +		 * be handled by EREMOVE-ing the SECS again after all pages in
> >>>> +		 * virtual EPC have been EREMOVE-ed. See comments in below in
> >>>> +		 * sgx_virt_epc_release().
> >>>> +		 */
> >>>> +		WARN_ON_ONCE(ret != SGX_CHILD_PRESENT);
> >>>> +		return ret;
> >>>> +	}
> >>> I find myself wondering what errors could cause the WARN_ON_ONCE() to be
> >>> hit.  The SDM indicates that it's only:
> >>>
> >>> 	SGX_ENCLAVE_ACT If there are still logical processors executing
> >>> 			inside the enclave.
> >>>
> >>> Should that be mentioned in the comment?
> >> And faults, which are also spliced into the return value by the ENCLS macros.
> >> I do remember hitting this WARN when I broke things, though I can't remember
> >> whether it was a fault or the SGX_ENCLAVE_ACT scenario.  Probably the latter?
> > I'll add a comment saying that there should be no active logical processor
> > still running inside guest's enclave. We cannot handle SGX_ENCLAVE_ACT here
> > anyway.
> 
> One more thing...
> 
> Could we dump out the *actual* error code with a WARN(), please?  If we
> see a warning, I'd rather not have to disassemble the instructions and
> check against register values to see whether the error code was sane.

Sure. But WARN_ONCE() should be used, right, instead of WARN()?
