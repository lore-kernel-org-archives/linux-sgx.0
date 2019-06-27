Return-Path: <SRS0=2cS5=U2=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81E0BC5B576
	for <linux-sgx@archiver.kernel.org>; Thu, 27 Jun 2019 22:07:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 46357208CB
	for <linux-sgx@archiver.kernel.org>; Thu, 27 Jun 2019 22:07:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=yahoo.com header.i=@yahoo.com header.b="Mu0AsF1a"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726498AbfF0WHG (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 27 Jun 2019 18:07:06 -0400
Received: from sonic301-38.consmr.mail.ne1.yahoo.com ([66.163.184.207]:33103
        "EHLO sonic301-38.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726606AbfF0WHG (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Thu, 27 Jun 2019 18:07:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1561673220; bh=V5k2rb962O0kGd279VyAqless2Sh0jEjYINir26oXfU=; h=Subject:To:Cc:References:From:Date:In-Reply-To:From:Subject; b=Mu0AsF1acm+AtcwSrIYm8+l0sLkD29086Il4HAEAXOhIYOIHea0uN8kAgKvOU+8IXxqXl5FNwW1AH73XYQevU7WK98yM9wF1XsZoifAAh8PBkllEQcfzhFx1D2LaEVMKxjjnnd/sNC3RB2upyxgOadUJ0u6uX34tn4H9RGQ2z86SHc2PnrZp4u+NcyEu1qgdRADSYUibCoeTe2sfi5S5f6D6+HzmO8tgzjVVXC8umllOfAgkqeqj8T/USJ0W8XImQwev8u+N5ZICaAn09FDFBjJ+H97PhdQMpAVTwq0MwXd4NqsA9xX4A1YT/Tc4lo2Z+UU85xf7iqXwmDkV6SHVWw==
X-YMail-OSG: ELu3p1sVM1mJUtYkyh6xLOZZfytk5h7Rw7vFNF7fOq0hmzIv..0Z9v63skU_Lea
 WzMoS30aHRkCVEKC1AiCgh4yq8Oygcs1RJZO.HmNdY1zeTpFgVTe9OD5RKVFPBAC_ZC.dW.LmYQx
 OeWYICfh3oWR5KkHtUwGGJccUYdHidZiWpDmbRYy3WJh3DzgRSSTgTgWwfs9qG_0ZEolRM3jjA4Z
 6Nk_QpSHXuPXAVbajlHf.n.Yd6sRo4Me5Pxz3WE1RqfYO08v93gbJGEDmMS3oZ7qJM0BLkgrZLBW
 ZmRPv8MnGWRkURmTI.Yeai3CJVDfWScxLoCSUAOsM0xI9pq2UWCAt4zXPLQiAzCdx4rfc7DOv1K2
 bGdzX7rgp1OXhwuKNAR660zDqdcbJAwjW74yCeRhXsYJipYrIs75nP42DvET38n.let8ttyxBEoP
 gvCiPDcTi6I.Un7V6rslvHgt4AexikZ6dobK80Hx_pvjlkH7wV47Bj1Mf2AgPM5gt_ukTjV7gPJP
 AdTbMsrQO6N5nVVqDGjyz6w8mkTyf6ZKHlin6bspw6hrZOt8IpX89_QO_tBormMpx80tcNH5Us0X
 QR7CRagWcrJV57aN8781ycWTWujfic.UHtswaSj_LhN2uHjtkhiBjLlT_vnUuRFaKhGEEp15ckxz
 bHQOFXO.WyZrG5UI_AhVhS2B8mw_5rpEv0m70QWQnMCN6178wBqU2Xv8gTGas_eZStITuL5g1kdj
 2gXw.EAWjIjmB50k2vNOLriMBQ6pca0ZqcLVumbjPCLs1Tjg.oJxr5yh8HPoCvqld_c4M7QSeIS2
 GxGQKXyNJaEqnMr9IDALum_Fm5Zveoa_IV5Bl_mBa34SFGLSDvX9hJocDiRoJ.OQ_bkxjT73pflK
 Tq9kpgwIo3RXW1ogIPxaDnpKWsWy.54TR_12BCuwwM7StjbJoAHghzMGaodT9Tg1CITpY3_7GX2B
 3YVEocwtIa0Hx4jyDB7xhk78RKuDnIWzZkjNHxTDkYSYZe.Z1Dwu_UZBp_QRyNedVh4.D1eL4u6X
 qUBtxQb2jS_nSG40gJMNIy8Hhbxc0rdP.HrX5tXkhBzB8EPXzlNjwq3.VB2IPW9Sk31Xfi4drBmU
 Hz.FxUH.JbhiO_8EFVVqs4wsS01nSHO4eZAnvL3pHXHFNkQxnb.pfAXuLjoaHtIx2Kg4doIi4ePp
 NGOh0T5YbHbluD7GLDjyRda20Pyq06DMy1.hBiBAPasNro5JpzwQ6xFea4iMYFlAoEeBGY3BOsh3
 SH6e384RTXlxZNdW0DOH2Z7CmrZByKKUo_UubHTdA3zBwN4TQ
Received: from sonic.gate.mail.ne1.yahoo.com by sonic301.consmr.mail.ne1.yahoo.com with HTTP; Thu, 27 Jun 2019 22:07:00 +0000
Received: from c-73-223-4-185.hsd1.ca.comcast.net (EHLO [192.168.0.103]) ([73.223.4.185])
          by smtp410.mail.ne1.yahoo.com (Oath Hermes SMTP Server) with ESMTPA ID fbd947b1a45eee1bf18b8f1756ae0d5a;
          Thu, 27 Jun 2019 22:06:56 +0000 (UTC)
Subject: Re: [RFC PATCH v2 1/3] x86/sgx: Add SGX specific LSM hooks
To:     Cedric Xing <cedric.xing@intel.com>, linux-sgx@vger.kernel.org,
        linux-security-module@vger.kernel.org, selinux@vger.kernel.org
Cc:     casey.schaufler@intel.com, jmorris@namei.org, luto@kernel.org,
        jethro@fortanix.com, greg@enjellic.com, sds@tycho.nsa.gov,
        jarkko.sakkinen@linux.intel.com, sean.j.christopherson@intel.com,
        casey@schaufler-ca.com
References: <cover.1561588012.git.cedric.xing@intel.com>
 <72420cff8fa944b64e57df8d25c63bd30f8aacfa.1561588012.git.cedric.xing@intel.com>
From:   Casey Schaufler <casey@schaufler-ca.com>
Openpgp: preference=signencrypt
Autocrypt: addr=casey@schaufler-ca.com; keydata=
 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
 abzjfg==
Message-ID: <b08798a5-65f7-f96e-1c04-39dd0e60c114@schaufler-ca.com>
Date:   Thu, 27 Jun 2019 15:06:55 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <72420cff8fa944b64e57df8d25c63bd30f8aacfa.1561588012.git.cedric.xing@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On 6/27/2019 11:56 AM, Cedric Xing wrote:
> SGX enclaves are loaded from pages in regular memory. Given the ability=
 to
> create executable pages, the newly added SGX subsystem may present a ba=
ckdoor
> for adversaries to circumvent LSM policies, such as creating an executa=
ble
> enclave page from a modified regular page that would otherwise not be m=
ade
> executable as prohibited by LSM. Therefore arises the primary question =
of
> whether an enclave page should be allowed to be created from a given so=
urce
> page in regular memory.
>
> A related question is whether to grant/deny a mprotect() request on a g=
iven
> enclave page/range. mprotect() is traditionally covered by
> security_file_mprotect() hook, however, enclave pages have a different =
lifespan
> than either MAP_PRIVATE or MAP_SHARED. Particularly, MAP_PRIVATE pages =
have the
> same lifespan as the VMA while MAP_SHARED pages have the same lifespan =
as the
> backing file (on disk), but enclave pages have the lifespan of the encl=
ave=E2=80=99s
> file descriptor. For example, enclave pages could be munmap()=E2=80=99e=
d then mmap()=E2=80=99ed
> again without losing contents (like MAP_SHARED), but all enclave pages =
will be
> lost once its file descriptor has been closed (like MAP_PRIVATE). That =
said,
> LSM modules need some new data structure for tracking protections of en=
clave
> pages/ranges so that they can make proper decisions at mmap()/mprotect(=
)
> syscalls.
>
> The last question, which is orthogonal to the 2 above, is whether or no=
t to
> allow a given enclave to launch/run. Enclave pages are not visible to t=
he rest
> of the system, so to some extent offer a better place for malicious sof=
tware to
> hide. Thus, it is sometimes desirable to whitelist/blacklist enclaves b=
y their
> measurements, signing public keys, or image files.
>
> To address the questions above, 2 new LSM hooks are added for enclaves.=

>   - security_enclave_load() =E2=80=93 This hook allows LSM to decide wh=
ether or not to
>     allow instantiation of a range of enclave pages using the specified=
 VMA. It
>     is invoked when a range of enclave pages is about to be loaded. It =
serves 3
>     purposes: 1) indicate to LSM that the file struct in subject is an =
enclave;
>     2) allow LSM to decide whether or not to instantiate those pages an=
d 3)
>     allow LSM to initialize internal data structures for tracking
>     origins/protections of those pages.
>   - security_enclave_init() =E2=80=93 This hook allows whitelisting/bla=
cklisting or
>     performing whatever checks deemed appropriate before an enclave is =
allowed
>     to run. An LSM module may opt to use the file backing the SIGSTRUCT=
 as a
>     proxy to dictate allowed protections for anonymous pages.
>
> mprotect() of enclave pages continue to be governed by
> security_file_mprotect(), with the expectation that LSM is able to dist=
inguish
> between regular and enclave pages inside the hook. For mmap(), the SGX
> subsystem is expected to invoke security_file_mprotect() explicitly to =
check
> protections against the requested protections for existing enclave page=
s. As
> stated earlier, enclave pages have different lifespan than the existing=

> MAP_PRIVATE and MAP_SHARED pages, so would require a new data structure=
 outside
> of VMA to track their protections and/or origins. Enclave Memory Area (=
or EMA
> for short) has been introduced to address the need. EMAs are maintained=
 by the
> LSM framework for all LSM modules to share. EMAs will be instantiated f=
or
> enclaves only so will not impose memory/performance overheads for regul=
ar
> applications/files. Please see include/linux/lsm_ema.h and security/lsm=
_ema.c
> for details.
>
> A new setup parameter =E2=80=93 lsm.ema.cache_decisions has been introd=
uced to offer
> the choice between memory consumption and accuracy of audit logs. Enabl=
ing
> lsm.ema.cache_decisions causes LSM framework NOT to keep backing files =
open for
> EMAs. While that saves memory, it requires LSM modules to make and cach=
e
> decisions ahead of time, and makes it difficult for LSM modules to gene=
rate
> accurate audit logs. System administrators are expected to run LSM in
> permissive mode with lsm.ema.cache_decisions off to determine the minim=
al
> permissions needed, and then turn it back on in enforcing mode for opti=
mal
> performance and memory usage. lsm.ema.cache_decisions is on by default =
and
> could be turned off by appending =E2=80=9Clsm.ema.cache_decisions=3D0=E2=
=80=9D or
> =E2=80=9Clsm.ema.cache_decisions=3Doff=E2=80=9D to the kernel command l=
ine.
>
> Signed-off-by: Cedric Xing <cedric.xing@intel.com>
> ---
>  include/linux/lsm_ema.h   | 171 ++++++++++++++++++++++++++++++++++++++=

>  include/linux/lsm_hooks.h |  29 +++++++
>  include/linux/security.h  |  23 +++++
>  security/Makefile         |   1 +
>  security/lsm_ema.c        | 132 +++++++++++++++++++++++++++++
>  security/security.c       |  47 ++++++++++-
>  6 files changed, 402 insertions(+), 1 deletion(-)
>  create mode 100644 include/linux/lsm_ema.h
>  create mode 100644 security/lsm_ema.c

Don't use "lsm_ema". This isn't LSM infrastructure.
Three letter abbreviations are easy to type, but are
doomed to encounter conflicts and lead to confusion.
I suggest that you use "enclave", because it doesn't
start off conflicting with anything and is descriptive.

This code should not be mixed in with the LSM infrastructure.
It should all be contained in its own module, under
security/enclave.

> diff --git a/include/linux/lsm_ema.h b/include/linux/lsm_ema.h
> new file mode 100644
> index 000000000000..a09b8f96da05
> --- /dev/null
> +++ b/include/linux/lsm_ema.h

There's no need for this header to be used outside the enclave
LSM. It should be "security/enclave/enclave.h"


> @@ -0,0 +1,171 @@
> +/* SPDX-License-Identifier: (GPL-2.0 OR BSD-3-Clause) */
> +/**
> + * Enclave Memory Area interface for LSM modules
> + *
> + * Copyright(c) 2016-19 Intel Corporation.
> + */
> +
> +#ifndef _LSM_EMA_H_
> +#define _LSM_EMA_H_
> +
> +#include <linux/list.h>
> +#include <linux/mutex.h>
> +#include <linux/fs.h>
> +#include <linux/file.h>
> +
> +/**
> + * lsm_ema - LSM Enclave Memory Area structure

How about s/lsm_ema/enclave/ ?

> + *
> + * Data structure to track origins of enclave pages
> + *
> + * @link:
> + *	Link to adjacent EMAs. EMAs are sorted by their addresses in ascend=
ing
> + *	order
> + * @start:
> + *	Starting address
> + * @end:
> + *	Ending address
> + * @source:
> + *	File from which this range was loaded from, or NULL if not loaded f=
rom
> + *	any files
> + */
> +struct lsm_ema {
> +	struct list_head	link;
> +	size_t			start;
> +	size_t			end;
> +	struct file		*source;
> +};
> +
> +#define lsm_ema_data(ema, blob_sizes)	\
> +	((char *)((struct lsm_ema *)(ema) + 1) + blob_sizes.lbs_ema_data)

Who uses this? The enclave LSM? Convention would have this
be selinux_enclave(ema) for the SELinux code. This is
inconsistent with the way other blobs are handled.

> +
> +/**
> + * lsm_ema_map - LSM Enclave Memory Map structure

enclave_map

> + *
> + * Container for EMAs of an enclave
> + *
> + * @list:
> + *	Head of a list of sorted EMAs
> + * @lock:
> + *	Acquire before querying/updateing the list EMAs
> + */
> +struct lsm_ema_map {
> +	struct list_head	list;
> +	struct mutex		lock;
> +};
> +
> +/**
> + * These are functions to be used by the LSM framework, and must be de=
fined
> + * regardless CONFIG_INTEL_SGX is enabled or not.

Not acceptable for the LSM infrastructure. They
are inconsistent with the way data is used there.

> + */
> +
> +#ifdef CONFIG_INTEL_SGX
> +void lsm_ema_global_init(size_t);
> +void lsm_free_ema_map(atomic_long_t *);
> +#else
> +static inline void lsm_ema_global_init(size_t ema_data_size)
> +{
> +}
> +
> +static inline void lsm_free_ema_map(atomic_long_t *p)
> +{
> +}
> +#endif
> +
> +/**
> + * Below are APIs to be used by LSM modules
> + */
> +
> +struct lsm_ema_map *lsm_init_or_get_ema_map(atomic_long_t *);
> +struct lsm_ema *lsm_alloc_ema(void);

Do you mean security_alloc_enclave()?
That would go into security/security.h

> +void lsm_free_ema(struct lsm_ema *);

Do you mean security_free_enclave()?
That would go into security/security.h

> +void lsm_init_ema(struct lsm_ema *, size_t, size_t, struct file *);

This goes in the enclave LSM.

> +int lsm_merge_ema(struct lsm_ema *, struct lsm_ema_map *);
> +struct lsm_ema *lsm_split_ema(struct lsm_ema *, size_t, struct lsm_ema=
_map *);
> +
> +static inline struct lsm_ema_map *lsm_get_ema_map(struct file *f)
> +{
> +	return (void *)atomic_long_read(f->f_security);
> +}
> +
> +static inline int __must_check lsm_lock_ema(struct lsm_ema_map *map)
> +{
> +	return mutex_lock_interruptible(&map->lock);
> +}
> +
> +static inline void lsm_unlock_ema(struct lsm_ema_map *map)
> +{
> +	mutex_unlock(&map->lock);
> +}
> +
> +static inline struct lsm_ema *lsm_prev_ema(struct lsm_ema *p,
> +					   struct lsm_ema_map *map)
> +{
> +	p =3D list_prev_entry(p, link);
> +	return &p->link =3D=3D &map->list ? NULL : p;
> +}
> +
> +static inline struct lsm_ema *lsm_next_ema(struct lsm_ema *p,
> +					   struct lsm_ema_map *map)
> +{
> +	p =3D list_next_entry(p, link);
> +	return &p->link =3D=3D &map->list ? NULL : p;
> +}
> +
> +static inline struct lsm_ema *lsm_find_ema(struct lsm_ema_map *map, si=
ze_t a)
> +{
> +	struct lsm_ema *p;
> +
> +	BUG_ON(!mutex_is_locked(&map->lock));
> +
> +	list_for_each_entry(p, &map->list, link)
> +		if (a < p->end)
> +			break;
> +	return &p->link =3D=3D &map->list ? NULL : p;
> +}
> +
> +static inline int lsm_insert_ema(struct lsm_ema_map *map, struct lsm_e=
ma *n)
> +{
> +	struct lsm_ema *p =3D lsm_find_ema(map, n->start);
> +
> +	if (!p)
> +		list_add_tail(&n->link, &map->list);
> +	else if (n->end <=3D p->start)
> +		list_add_tail(&n->link, &p->link);
> +	else
> +		return -EEXIST;
> +
> +	lsm_merge_ema(n, map);
> +	if (p)
> +		lsm_merge_ema(p, map);
> +	return 0;
> +}
> +
> +static inline int lsm_for_each_ema(struct lsm_ema_map *map, size_t sta=
rt,
> +				   size_t end, int (*cb)(struct lsm_ema *,
> +							 void *), void *arg)
> +{
> +	struct lsm_ema *ema;
> +	int rc;
> +
> +	ema =3D lsm_find_ema(map, start);
> +	while (ema && end > ema->start) {
> +		if (start > ema->start)
> +			lsm_split_ema(ema, start, map);
> +		if (end < ema->end)
> +			ema =3D lsm_split_ema(ema, end, map);
> +
> +		rc =3D (*cb)(ema, arg);
> +		lsm_merge_ema(ema, map);
> +		if (rc)
> +			return rc;
> +
> +		ema =3D lsm_next_ema(ema, map);
> +	}
> +
> +	if (ema)
> +		lsm_merge_ema(ema, map);
> +	return 0;
> +}

There is no way that these belong as part of the LSM
infrastructure. If you need an enclave management API
you need to find some other place for it.

> +
> +#endif /* _LSM_EMA_H_ */
> diff --git a/include/linux/lsm_hooks.h b/include/linux/lsm_hooks.h
> index 47f58cfb6a19..ade1f9f81e64 100644
> --- a/include/linux/lsm_hooks.h
> +++ b/include/linux/lsm_hooks.h
> @@ -29,6 +29,8 @@
>  #include <linux/init.h>
>  #include <linux/rculist.h>
> =20
> +struct lsm_ema;
> +
>  /**
>   * union security_list_options - Linux Security Module hook function l=
ist
>   *
> @@ -1446,6 +1448,21 @@
>   * @bpf_prog_free_security:
>   *	Clean up the security information stored inside bpf prog.
>   *
> + * @enclave_load:
> + *	Decide if a range of pages shall be allowed to be loaded into an
> + *	enclave
> + *
> + *	@encl points to the file identifying the target enclave
> + *	@ema specifies the target range to be loaded
> + *	@flags contains protections being requested for the target range
> + *	@source points to the VMA containing the source pages to be loaded
> + *
> + * @enclave_init:
> + *	Decide if an enclave shall be allowed to launch
> + *
> + *	@encl points to the file identifying the target enclave being launc=
hed
> + *	@sigstruct contains a copy of the SIGSTRUCT in kernel memory
> + *	@source points to the VMA backing SIGSTRUCT in user memory
>   */
>  union security_list_options {
>  	int (*binder_set_context_mgr)(struct task_struct *mgr);
> @@ -1807,6 +1824,13 @@ union security_list_options {
>  	int (*bpf_prog_alloc_security)(struct bpf_prog_aux *aux);
>  	void (*bpf_prog_free_security)(struct bpf_prog_aux *aux);
>  #endif /* CONFIG_BPF_SYSCALL */
> +
> +#ifdef CONFIG_INTEL_SGX
> +	int (*enclave_load)(struct file *encl, struct lsm_ema *ema,
> +			    size_t flags, struct vm_area_struct *source);
> +	int (*enclave_init)(struct file *encl, struct sgx_sigstruct *sigstruc=
t,
> +			    struct vm_area_struct *source);
> +#endif
>  };
> =20
>  struct security_hook_heads {
> @@ -2046,6 +2070,10 @@ struct security_hook_heads {
>  	struct hlist_head bpf_prog_alloc_security;
>  	struct hlist_head bpf_prog_free_security;
>  #endif /* CONFIG_BPF_SYSCALL */
> +#ifdef CONFIG_INTEL_SGX
> +	struct hlist_head enclave_load;
> +	struct hlist_head enclave_init;
> +#endif
>  } __randomize_layout;
> =20
>  /*
> @@ -2069,6 +2097,7 @@ struct lsm_blob_sizes {
>  	int	lbs_ipc;
>  	int	lbs_msg_msg;
>  	int	lbs_task;
> +	int	lbs_ema_data;

Is a module like SELinux expected to have its own
data for enclave? That's the only case where you would
have a enclave entry in the blob.

>  };
> =20
>  /*
> diff --git a/include/linux/security.h b/include/linux/security.h
> index 659071c2e57c..52c200810004 100644
> --- a/include/linux/security.h
> +++ b/include/linux/security.h
> @@ -1829,5 +1829,28 @@ static inline void security_bpf_prog_free(struct=
 bpf_prog_aux *aux)
>  #endif /* CONFIG_SECURITY */
>  #endif /* CONFIG_BPF_SYSCALL */
> =20
> +#ifdef CONFIG_INTEL_SGX
> +struct sgx_sigstruct;
> +#ifdef CONFIG_SECURITY
> +int security_enclave_load(struct file *encl, size_t start, size_t end,=

> +			  size_t flags, struct vm_area_struct *source);
> +int security_enclave_init(struct file *encl, struct sgx_sigstruct *sig=
struct,
> +			  struct vm_area_struct *source);
> +#else
> +static inline int security_enclave_load(struct file *encl, size_t star=
t,
> +					size_t end, struct vm_area_struct *src)
> +{
> +	return 0;
> +}
> +
> +static inline int security_enclave_init(struct file *encl,
> +					struct sgx_sigstruct *sigstruct,
> +					struct vm_area_struct *src)
> +{
> +	return 0;
> +}
> +#endif /* CONFIG_SECURITY */
> +#endif /* CONFIG_INTEL_SGX */
> +
>  #endif /* ! __LINUX_SECURITY_H */
> =20
> diff --git a/security/Makefile b/security/Makefile
> index c598b904938f..1bab8f1344b6 100644
> --- a/security/Makefile
> +++ b/security/Makefile
> @@ -28,6 +28,7 @@ obj-$(CONFIG_SECURITY_YAMA)		+=3D yama/
>  obj-$(CONFIG_SECURITY_LOADPIN)		+=3D loadpin/
>  obj-$(CONFIG_SECURITY_SAFESETID)       +=3D safesetid/
>  obj-$(CONFIG_CGROUP_DEVICE)		+=3D device_cgroup.o
> +obj-$(CONFIG_INTEL_SGX)			+=3D lsm_ema.o

This belongs in a subdirectory.

> =20
>  # Object integrity file lists
>  subdir-$(CONFIG_INTEGRITY)		+=3D integrity
> diff --git a/security/lsm_ema.c b/security/lsm_ema.c
> new file mode 100644
> index 000000000000..68fae0724d37
> --- /dev/null
> +++ b/security/lsm_ema.c
> @@ -0,0 +1,132 @@
> +// SPDX-License-Identifier: (GPL-2.0 OR BSD-3-Clause)
> +// Copyright(c) 2016-18 Intel Corporation.
> +
> +#include <linux/lsm_ema.h>
> +#include <linux/slab.h>
> +
> +static struct kmem_cache *lsm_ema_cache;
> +static size_t lsm_ema_data_size;
> +static int lsm_ema_cache_decisions =3D 1;
> +
> +void lsm_ema_global_init(size_t ema_size)
> +{
> +	BUG_ON(lsm_ema_data_size > 0);
> +
> +	lsm_ema_data_size =3D ema_size;
> +
> +	ema_size +=3D sizeof(struct lsm_ema);
> +	ema_size =3D max(ema_size, sizeof(struct lsm_ema_map));
> +	lsm_ema_cache =3D kmem_cache_create("lsm_ema_cache", ema_size,
> +					  __alignof__(struct lsm_ema),
> +					  SLAB_PANIC, NULL);
> +
> +}
> +
> +struct lsm_ema_map *lsm_init_or_get_ema_map(atomic_long_t *p)
> +{
> +	struct lsm_ema_map *map;
> +
> +	map =3D (typeof(map))atomic_long_read(p);
> +	if (!map) {
> +		long n;
> +
> +		map =3D (typeof(map))lsm_alloc_ema();
> +		if (!map)
> +			return NULL;
> +
> +		INIT_LIST_HEAD(&map->list);
> +		mutex_init(&map->lock);
> +
> +		n =3D atomic_long_cmpxchg(p, 0, (long)map);
> +		if (n) {
> +			atomic_long_t a;
> +			atomic_long_set(&a, (long)map);
> +			map =3D (typeof(map))n;
> +			lsm_free_ema_map(&a);
> +		}
> +	}
> +	return map;
> +}
> +
> +void lsm_free_ema_map(atomic_long_t *p)
> +{
> +	struct lsm_ema_map *map;
> +	struct lsm_ema *ema, *n;
> +
> +	map =3D (typeof(map))atomic_long_read(p);
> +	if (!map)
> +		return;
> +
> +	BUG_ON(mutex_is_locked(&map->lock));
> +
> +	list_for_each_entry_safe(ema, n, &map->list, link)
> +		lsm_free_ema(ema);
> +	kmem_cache_free(lsm_ema_cache, map);
> +}
> +
> +struct lsm_ema *lsm_alloc_ema(void)
> +{
> +	return kmem_cache_zalloc(lsm_ema_cache, GFP_KERNEL);
> +}
> +
> +void lsm_free_ema(struct lsm_ema *ema)
> +{
> +	list_del(&ema->link);
> +	if (ema->source)
> +		fput(ema->source);
> +	kmem_cache_free(lsm_ema_cache, ema);
> +}
> +
> +void lsm_init_ema(struct lsm_ema *ema, size_t start, size_t end,
> +		  struct file *source)
> +{
> +	INIT_LIST_HEAD(&ema->link);
> +	ema->start =3D start;
> +	ema->end =3D end;
> +	if (!lsm_ema_cache_decisions && source)
> +		ema->source =3D get_file(source);
> +}
> +
> +int lsm_merge_ema(struct lsm_ema *p, struct lsm_ema_map *map)
> +{
> +	struct lsm_ema *prev =3D list_prev_entry(p, link);
> +
> +	BUG_ON(!mutex_is_locked(&map->lock));
> +
> +	if (&prev->link =3D=3D &map->list || prev->end !=3D p->start ||
> +	    prev->source !=3D p->source ||
> +	    memcmp(prev + 1, p + 1, lsm_ema_data_size))
> +		return 0;
> +
> +	p->start =3D prev->start;
> +	fput(prev->source);
> +	lsm_free_ema(prev);
> +	return 1;
> +}
> +
> +struct lsm_ema *lsm_split_ema(struct lsm_ema *p, size_t at,
> +			      struct lsm_ema_map *map)
> +{
> +	struct lsm_ema *n;
> +
> +	BUG_ON(!mutex_is_locked(&map->lock));
> +
> +	if (at <=3D p->start || at >=3D p->end)
> +		return p;
> +
> +	n =3D lsm_alloc_ema();
> +	if (likely(n)) {
> +		lsm_init_ema(n, p->start, at, p->source);
> +		memcpy(n + 1, p + 1, lsm_ema_data_size);
> +		p->start =3D at;
> +		list_add_tail(&n->link, &p->link);
> +	}
> +	return n;
> +}
> +
> +static int __init set_ema_cache_decisions(char *str)
> +{
> +	lsm_ema_cache_decisions =3D (strcmp(str, "0") && strcmp(str, "off"));=

> +	return 1;
> +}
> +__setup("lsm.ema.cache_decisions=3D", set_ema_cache_decisions);
> diff --git a/security/security.c b/security/security.c
> index f493db0bf62a..d50883f18be2 100644
> --- a/security/security.c
> +++ b/security/security.c
> @@ -17,6 +17,7 @@
>  #include <linux/init.h>
>  #include <linux/kernel.h>
>  #include <linux/lsm_hooks.h>
> +#include <linux/lsm_ema.h>
>  #include <linux/integrity.h>
>  #include <linux/ima.h>
>  #include <linux/evm.h>
> @@ -41,7 +42,9 @@ static struct kmem_cache *lsm_file_cache;
>  static struct kmem_cache *lsm_inode_cache;
> =20
>  char *lsm_names;
> -static struct lsm_blob_sizes blob_sizes __lsm_ro_after_init;
> +static struct lsm_blob_sizes blob_sizes __lsm_ro_after_init =3D {
> +	.lbs_file =3D sizeof(atomic_long_t) * IS_ENABLED(CONFIG_INTEL_SGX),
> +};

This belongs in the module specific code.
It does not belong here.

> =20
>  /* Boot-time LSM user choice */
>  static __initdata const char *chosen_lsm_order;
> @@ -169,6 +172,7 @@ static void __init lsm_set_blob_sizes(struct lsm_bl=
ob_sizes *needed)
>  	lsm_set_blob_size(&needed->lbs_ipc, &blob_sizes.lbs_ipc);
>  	lsm_set_blob_size(&needed->lbs_msg_msg, &blob_sizes.lbs_msg_msg);
>  	lsm_set_blob_size(&needed->lbs_task, &blob_sizes.lbs_task);
> +	lsm_set_blob_size(&needed->lbs_ema_data, &blob_sizes.lbs_ema_data);
>  }
> =20
>  /* Prepare LSM for initialization. */
> @@ -314,6 +318,7 @@ static void __init ordered_lsm_init(void)
>  		lsm_inode_cache =3D kmem_cache_create("lsm_inode_cache",
>  						    blob_sizes.lbs_inode, 0,
>  						    SLAB_PANIC, NULL);
> +	lsm_ema_global_init(blob_sizes.lbs_ema_data);
> =20
>  	lsm_early_cred((struct cred *) current->cred);
>  	lsm_early_task(current);
> @@ -1357,6 +1362,7 @@ void security_file_free(struct file *file)
>  	blob =3D file->f_security;
>  	if (blob) {
>  		file->f_security =3D NULL;
> +		lsm_free_ema_map(blob);
>  		kmem_cache_free(lsm_file_cache, blob);
>  	}
>  }
> @@ -1420,6 +1426,7 @@ int security_file_mprotect(struct vm_area_struct =
*vma, unsigned long reqprot,
>  {
>  	return call_int_hook(file_mprotect, 0, vma, reqprot, prot);
>  }
> +EXPORT_SYMBOL(security_file_mprotect);
> =20
>  int security_file_lock(struct file *file, unsigned int cmd)
>  {
> @@ -2355,3 +2362,41 @@ void security_bpf_prog_free(struct bpf_prog_aux =
*aux)
>  	call_void_hook(bpf_prog_free_security, aux);
>  }
>  #endif /* CONFIG_BPF_SYSCALL */
> +
> +#ifdef CONFIG_INTEL_SGX
> +int security_enclave_load(struct file *encl, size_t start, size_t end,=

> +			  size_t flags, struct vm_area_struct *src)

You are mixing module specific code into the infrastructure.
All of this should be in the enclave code. None of it should be here.

> +{
> +	struct lsm_ema_map *map;
> +	struct lsm_ema *ema;
> +	int rc;
> +
> +	map =3D lsm_init_or_get_ema_map(encl->f_security);
> +	if (unlikely(!map))
> +		return -ENOMEM;
> +
> +	ema =3D lsm_alloc_ema();
> +	if (unlikely(!ema))
> +		return -ENOMEM;
> +
> +	lsm_init_ema(ema, start, end, src->vm_file);
> +	rc =3D call_int_hook(enclave_load, 0, encl, ema, flags, src);
> +	if (!rc)
> +		rc =3D lsm_lock_ema(map);
> +	if (!rc) {
> +		rc =3D lsm_insert_ema(map, ema);
> +		lsm_unlock_ema(map);
> +	}
> +	if (rc)
> +		lsm_free_ema(ema);
> +	return rc;
> +}
> +EXPORT_SYMBOL(security_enclave_load);
> +
> +int security_enclave_init(struct file *encl, struct sgx_sigstruct *sig=
struct,
> +			  struct vm_area_struct *src)
> +{
> +	return call_int_hook(enclave_init, 0, encl, sigstruct, src);
> +}
> +EXPORT_SYMBOL(security_enclave_init);
> +#endif /* CONFIG_INTEL_SGX */

