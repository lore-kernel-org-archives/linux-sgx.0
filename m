Return-Path: <SRS0=YVcv=UJ=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C58F7C31E41
	for <linux-sgx@archiver.kernel.org>; Mon, 10 Jun 2019 16:00:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A51AE21726
	for <linux-sgx@archiver.kernel.org>; Mon, 10 Jun 2019 16:00:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390335AbfFJQAc (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 10 Jun 2019 12:00:32 -0400
Received: from mga18.intel.com ([134.134.136.126]:54869 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389356AbfFJQAb (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 10 Jun 2019 12:00:31 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 10 Jun 2019 09:00:31 -0700
X-ExtLoop1: 1
Received: from cmargarx-wtg.ger.corp.intel.com (HELO localhost) ([10.249.34.77])
  by orsmga001.jf.intel.com with ESMTP; 10 Jun 2019 09:00:19 -0700
Date:   Mon, 10 Jun 2019 19:00:18 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Andy Lutomirski <luto@kernel.org>,
        Cedric Xing <cedric.xing@intel.com>,
        Stephen Smalley <sds@tycho.nsa.gov>,
        James Morris <jmorris@namei.org>,
        "Serge E . Hallyn" <serge@hallyn.com>,
        LSM List <linux-security-module@vger.kernel.org>,
        Paul Moore <paul@paul-moore.com>,
        Eric Paris <eparis@parisplace.org>, selinux@vger.kernel.org,
        Jethro Beekman <jethro@fortanix.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>,
        linux-sgx@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>, nhorman@redhat.com,
        npmccallum@redhat.com, Serge Ayoun <serge.ayoun@intel.com>,
        Shay Katz-zamir <shay.katz-zamir@intel.com>,
        Haitao Huang <haitao.huang@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Kai Svahn <kai.svahn@intel.com>,
        Borislav Petkov <bp@alien8.de>,
        Josh Triplett <josh@joshtriplett.org>,
        Kai Huang <kai.huang@intel.com>,
        David Rientjes <rientjes@google.com>,
        William Roberts <william.c.roberts@intel.com>,
        Philip Tricca <philip.b.tricca@intel.com>
Subject: Re: [RFC PATCH v2 3/5] x86/sgx: Enforce noexec filesystem
 restriction for enclaves
Message-ID: <20190610160005.GC3752@linux.intel.com>
References: <20190606021145.12604-1-sean.j.christopherson@intel.com>
 <20190606021145.12604-4-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190606021145.12604-4-sean.j.christopherson@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Jun 05, 2019 at 07:11:43PM -0700, Sean Christopherson wrote:
> +		goto out;
> +	}
> +
> +	/*
> +	 * Query VM_MAYEXEC as an indirect path_noexec() check (see do_mmap()),
> +	 * but with some future proofing against other cases that may deny
> +	 * execute permissions.
> +	 */
> +	if (!(vma->vm_flags & VM_MAYEXEC)) {
> +		ret = -EACCES;
> +		goto out;
> +	}
> +
> +	if (copy_from_user(dst, (void __user *)src, PAGE_SIZE))
> +		ret = -EFAULT;
> +	else
> +		ret = 0;
> +
> +out:
> +	up_read(&current->mm->mmap_sem);
> +
> +	return ret;
> +}

I would suggest to express the above instead like this for clarity
and consistency:

		goto err_map_sem;
	}

	/* Query VM_MAYEXEC as an indirect path_noexec() check
	 * (see do_mmap()).
	 */
	if (!(vma->vm_flags & VM_MAYEXEC)) {
		ret = -EACCES;
		goto err_mmap_sem;
	}

	if (copy_from_user(dst, (void __user *)src, PAGE_SIZE)) {
		ret = -EFAULT;
		goto err_mmap_sem;
	}

	return 0;

err_mmap_sem:
	up_read(&current->mm->mmap_sem);
	return ret;
}

The comment about future proofing is unnecessary.

/Jarkk
