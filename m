Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B78CC433DB
	for <linux-sgx@archiver.kernel.org>; Tue,  2 Mar 2021 21:40:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4E48764F31
	for <linux-sgx@archiver.kernel.org>; Tue,  2 Mar 2021 21:40:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237336AbhCBVgW (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 2 Mar 2021 16:36:22 -0500
Received: from mga12.intel.com ([192.55.52.136]:45957 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239410AbhCBAem (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 1 Mar 2021 19:34:42 -0500
IronPort-SDR: teJSunGn2YfXcddnV8jQUrkXr+CWtUJxoe9WmvWCaISnf/ZLt2PJWe2rl844eP99Wfcmv0+sio
 /kSjES+Ms0eA==
X-IronPort-AV: E=McAfee;i="6000,8403,9910"; a="165876023"
X-IronPort-AV: E=Sophos;i="5.81,216,1610438400"; 
   d="scan'208";a="165876023"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Mar 2021 16:33:30 -0800
IronPort-SDR: B58ZcTzZmcU0362ckwQq/JR/LNXD9HJW1us1lMj/ckphbY1t7jYC7xrlA/FAcYzL5SIObYyRZ2
 Nt2tON3glSEA==
X-IronPort-AV: E=Sophos;i="5.81,216,1610438400"; 
   d="scan'208";a="427144376"
Received: from yueliu2-mobl.amr.corp.intel.com ([10.252.139.111])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Mar 2021 16:33:25 -0800
Message-ID: <4178fc1a04af49a85d53cb1f5c122b42e02a14e4.camel@intel.com>
Subject: Re: [PATCH 05/25] x86/sgx: Introduce virtual EPC for use by KVM
 guests
From:   Kai Huang <kai.huang@intel.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org, jarkko@kernel.org, luto@kernel.org,
        dave.hansen@intel.com, rick.p.edgecombe@intel.com,
        haitao.huang@intel.com, pbonzini@redhat.com, bp@alien8.de,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Date:   Tue, 02 Mar 2021 13:33:22 +1300
In-Reply-To: <YD0Uf1LS4jDlXGLo@google.com>
References: <cover.1614590788.git.kai.huang@intel.com>
         <aade4006c3474175f97ec149a969eb02f1720a89.1614590788.git.kai.huang@intel.com>
         <YD0Uf1LS4jDlXGLo@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, 2021-03-01 at 08:21 -0800, Sean Christopherson wrote:
> On Mon, Mar 01, 2021, Kai Huang wrote:
> > +	/*
> > +	 * SECS pages are "pinned" by child pages, an unpinned once all
> 
> s/an/and

Thanks!

> 
> > +	 * children have been EREMOVE'd.  A child page in this instance
> > +	 * may have pinned an SECS page encountered in an earlier release(),
> > +	 * creating a zombie.  Since some children were EREMOVE'd above,
> > +	 * try to EREMOVE all zombies in the hopes that one was unpinned.
> > +	 */
> > +	mutex_lock(&zombie_secs_pages_lock);
> > +	list_for_each_entry_safe(epc_page, tmp, &zombie_secs_pages, list) {
> > +		/*
> > +		 * Speculatively remove the page from the list of zombies,
> > +		 * if the page is successfully EREMOVE it will be added to
> > +		 * the list of free pages.  If EREMOVE fails, throw the page
> > +		 * on the local list, which will be spliced on at the end.
> > +		 */
> > +		list_del(&epc_page->list);
> > +
> > +		if (sgx_vepc_free_page(epc_page))
> > +			list_add_tail(&epc_page->list, &secs_pages);
> > +	}
> > +
> > +	if (!list_empty(&secs_pages))
> > +		list_splice_tail(&secs_pages, &zombie_secs_pages);
> > +	mutex_unlock(&zombie_secs_pages_lock);
> > +
> > +	kfree(vepc);
> > +
> > +	return 0;
> > +}


