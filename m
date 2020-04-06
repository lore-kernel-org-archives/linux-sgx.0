Return-Path: <SRS0=PPLm=5W=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C277C2BA1A
	for <linux-sgx@archiver.kernel.org>; Mon,  6 Apr 2020 23:18:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CAB43206C3
	for <linux-sgx@archiver.kernel.org>; Mon,  6 Apr 2020 23:18:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1586215116;
	bh=hu1K3vX6lOi8XYU1VyyZEYLzAuiURWCFgJMNxq3R/nI=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=yrBzp42gJWoALal2CUVBIti3eALf59Ju45v9WHfJlyihVi1HMeKbicFULjDeJSVwE
	 RuSacBIA8e2IWv5McJ7tMFrKYRShIu0NFGs6Vod/xjoyghroltiLSmFgV8DB+oj+T5
	 7LvtN4z4labF07bOzZHy5asel3jnjAutUha84DB8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726303AbgDFXSf (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 6 Apr 2020 19:18:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:36672 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726272AbgDFXSf (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 6 Apr 2020 19:18:35 -0400
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BB19F206C3
        for <linux-sgx@vger.kernel.org>; Mon,  6 Apr 2020 23:18:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586215115;
        bh=hu1K3vX6lOi8XYU1VyyZEYLzAuiURWCFgJMNxq3R/nI=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=SE+XqTus2wf9JktTPQeQfJQjJC+ISlioPuC1qf4rUQ6/iy6tT1DVhIzOfA7+XMA13
         +mkxfvL+te7FoLf89eNlOlm+zKnfWdIp+Cw5nYC6DEEqVtOY7lTIF7Wwi5o/ENcJ6K
         bET3YqUl+PBCjhchP/xmTUE79h7QFNnXLzyJJfSE=
Received: by mail-wr1-f43.google.com with SMTP id s8so1616827wrt.7
        for <linux-sgx@vger.kernel.org>; Mon, 06 Apr 2020 16:18:34 -0700 (PDT)
X-Gm-Message-State: AGi0PubHc8d8hnZgmmANwRgwsnPQLXGuvyRx8jrFsZpgkkyTmMzAWerF
        M4iZTHUsxAorUn6VSfTENVoZR60CEpkXOOPU5eR9Eg==
X-Google-Smtp-Source: APiQypLlkYpxI0LzjvXmgsiRwPqULe3WuQ8+osY/aHH+oUubpE0+TWnRLwXL4so9svvjSEfMIPe860/vqr4V9HY1DMI=
X-Received: by 2002:a5d:460c:: with SMTP id t12mr1616089wrq.75.1586215113216;
 Mon, 06 Apr 2020 16:18:33 -0700 (PDT)
MIME-Version: 1.0
References: <20200406185530.GE20105@linux.intel.com> <F4B63BCD-F554-4BE2-B3AE-4ADB6C2F4285@amacapital.net>
 <20200406212434.GA34134@linux.intel.com>
In-Reply-To: <20200406212434.GA34134@linux.intel.com>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Mon, 6 Apr 2020 16:18:20 -0700
X-Gmail-Original-Message-ID: <CALCETrWkaUS2RU61_4KoNhn3RkW-J+SWiCQTZ623wu4b7snJ0w@mail.gmail.com>
Message-ID: <CALCETrWkaUS2RU61_4KoNhn3RkW-J+SWiCQTZ623wu4b7snJ0w@mail.gmail.com>
Subject: Re: [PATCH 2/4] x86/sgx: Put enclaves into anonymous files
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     Topi Miettinen <toiwoton@gmail.com>,
        Jethro Beekman <jethro@fortanix.com>,
        Casey Schaufler <casey@schaufler-ca.com>,
        Andy Lutomirski <luto@kernel.org>,
        "Schaufler, Casey" <casey.schaufler@intel.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        linux-sgx@vger.kernel.org, "Svahn, Kai" <kai.svahn@intel.com>,
        "Schlobohm, Bruce" <bruce.schlobohm@intel.com>,
        Stephen Smalley <sds@tycho.nsa.gov>,
        Haitao Huang <haitao.huang@linux.intel.com>,
        Ben Hutchings <ben@decadent.org.uk>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Apr 6, 2020 at 2:24 PM Jarkko Sakkinen
<jarkko.sakkinen@linux.intel.com> wrote:
>
> On Mon, Apr 06, 2020 at 12:53:41PM -0700, Andy Lutomirski wrote:
> > > sgxfs is somewhat trivial to implement and has one stakeholder less t=
o
> > > worry about. It is not really a huge stretch.
> > >
> > > Overally, I think it is something that we could live with. At least i=
t
> > > is something that does not step on others toes.
> > >
> > > Haitao: If we go with sgxfs route, then you can for the moment do wha=
t
> > > Andy suggested: bind mount it to /dev/sgx.
> >
> > That also needs userspace support.
> >
> > I=E2=80=99ll start a thread on the udev list.
>
> Haven't written any code yet but just by drafting the idea I already
> pinpointed something.
>
> You would add roughly this to the existing codebase:
>
> * struct file_system_type sgxfs
> * struct fs_context_operations sgxfs_ctx_ops
> * int sgxfs_get_tree()
> * int sgxfs_fill_super()
> * const struct tree_descr sgxfs_files[]
>
> The files would be defined as like this:
>
> static const struct tree_descr sgxfs_files[] {
>         [SGXFS_ENCLAVE] =3D { "enclave", &sgxfs_encl_ops, /* ? */ },
>         [SGXFS_PROVISION] =3D { "provision", &sgxfs_encl_ops, /* ? */ },
> };
>
> The permissions would need to be completely static, which feels nasty
> from maintainability viewpoint :-( And I see no gain anywhere.
>
> In my opinion udev defining the whole /dev as noexec has zero technical
> merits. It is same as they would say that "we don't trust our own
> database". There are no real security benefits as long as dev nodes are
> configured correctly.

I tend to agree, but it could be seen as a sort-of-valid hardening measure.

I think the best bet is for you to ignore this and let userspace figure it =
out.
