Return-Path: <SRS0=PPLm=5W=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE9D2C2BA1A
	for <linux-sgx@archiver.kernel.org>; Mon,  6 Apr 2020 23:48:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BDD6420768
	for <linux-sgx@archiver.kernel.org>; Mon,  6 Apr 2020 23:48:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726446AbgDFXs1 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 6 Apr 2020 19:48:27 -0400
Received: from mga18.intel.com ([134.134.136.126]:14845 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726399AbgDFXs1 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 6 Apr 2020 19:48:27 -0400
IronPort-SDR: vKvGJ9a1LAXSIOpbaW6oRvTyk5zEMJbnEcpXzMFnCAzKUek9zjb5LkKt4nWCiUsOwkhQ4WVJbW
 AuamK85HiY0Q==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Apr 2020 16:48:26 -0700
IronPort-SDR: xGzO8GhiBvZBRG9//UHYBayOhKYujD5XE9fzlgqC3dYdjQxA/vxzzjvhSDrbiheaz+k0QfyWZM
 g9amB7aJGBLg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,352,1580803200"; 
   d="scan'208";a="274909843"
Received: from sneaga-mobl2.ger.corp.intel.com (HELO localhost) ([10.252.49.185])
  by fmsmga004.fm.intel.com with ESMTP; 06 Apr 2020 16:48:21 -0700
Date:   Tue, 7 Apr 2020 02:48:20 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Andy Lutomirski <luto@kernel.org>
Cc:     Topi Miettinen <toiwoton@gmail.com>,
        Jethro Beekman <jethro@fortanix.com>,
        Casey Schaufler <casey@schaufler-ca.com>,
        "Schaufler, Casey" <casey.schaufler@intel.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        linux-sgx@vger.kernel.org, "Svahn, Kai" <kai.svahn@intel.com>,
        "Schlobohm, Bruce" <bruce.schlobohm@intel.com>,
        Stephen Smalley <sds@tycho.nsa.gov>,
        Haitao Huang <haitao.huang@linux.intel.com>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: Re: [PATCH 2/4] x86/sgx: Put enclaves into anonymous files
Message-ID: <20200406234820.GA3956@linux.intel.com>
References: <20200406185530.GE20105@linux.intel.com>
 <F4B63BCD-F554-4BE2-B3AE-4ADB6C2F4285@amacapital.net>
 <20200406212434.GA34134@linux.intel.com>
 <CALCETrWkaUS2RU61_4KoNhn3RkW-J+SWiCQTZ623wu4b7snJ0w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CALCETrWkaUS2RU61_4KoNhn3RkW-J+SWiCQTZ623wu4b7snJ0w@mail.gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Apr 06, 2020 at 04:18:20PM -0700, Andy Lutomirski wrote:
> On Mon, Apr 6, 2020 at 2:24 PM Jarkko Sakkinen
> <jarkko.sakkinen@linux.intel.com> wrote:
> >
> > On Mon, Apr 06, 2020 at 12:53:41PM -0700, Andy Lutomirski wrote:
> > > > sgxfs is somewhat trivial to implement and has one stakeholder less to
> > > > worry about. It is not really a huge stretch.
> > > >
> > > > Overally, I think it is something that we could live with. At least it
> > > > is something that does not step on others toes.
> > > >
> > > > Haitao: If we go with sgxfs route, then you can for the moment do what
> > > > Andy suggested: bind mount it to /dev/sgx.
> > >
> > > That also needs userspace support.
> > >
> > > I’ll start a thread on the udev list.
> >
> > Haven't written any code yet but just by drafting the idea I already
> > pinpointed something.
> >
> > You would add roughly this to the existing codebase:
> >
> > * struct file_system_type sgxfs
> > * struct fs_context_operations sgxfs_ctx_ops
> > * int sgxfs_get_tree()
> > * int sgxfs_fill_super()
> > * const struct tree_descr sgxfs_files[]
> >
> > The files would be defined as like this:
> >
> > static const struct tree_descr sgxfs_files[] {
> >         [SGXFS_ENCLAVE] = { "enclave", &sgxfs_encl_ops, /* ? */ },
> >         [SGXFS_PROVISION] = { "provision", &sgxfs_encl_ops, /* ? */ },
> > };
> >
> > The permissions would need to be completely static, which feels nasty
> > from maintainability viewpoint :-( And I see no gain anywhere.
> >
> > In my opinion udev defining the whole /dev as noexec has zero technical
> > merits. It is same as they would say that "we don't trust our own
> > database". There are no real security benefits as long as dev nodes are
> > configured correctly.
> 
> I tend to agree, but it could be seen as a sort-of-valid hardening measure.

Bets are not great anyway to revert it so lets just consider it as a
constraint then.

> I think the best bet is for you to ignore this and let userspace figure it out.

Yeah. You could put statically 0700 permissions and then let systemd to
set the legit ones but it just feels a way too big hammer to do a new fs
just to sort out a simple permission issue.

/Jarkko
